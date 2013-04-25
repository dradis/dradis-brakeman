module BrakemanUpload  
  private
  @@logger=nil

  public
  
  # This method will be called by the framework when the user selects your 
  # plugin from the drop down list of the 'Import from file' dialog
  def self.import(params={})
    file_content = File.read( params[:file] )
    @@logger = params.fetch(:logger, Rails.logger)

    # TODO: do something with the contents of the file!
    # if you want to print out something to the screen or to the uploader 
    # interface use @@logger.info("Your message")

    # We'll create a bunch of Nodes/Notes, we need to initialize some details:
    #
    # get the "Plugin output" category instance or create it if it does not exist
    @category = Category.find_or_create_by_name(Configuration.category)
    # every note we create will be assigned to this author
    @author = Configuration.author
    # create the parent early so we can use it to provide feedback and errors
    @parent = Node.find_or_create_by_label(Configuration.parent_node)

    # Parse the uploaded file into a Ruby Hash
    data = MultiJson.decode(file_content)
    # @@logger.debug{ data }


    scan_info = "#[Application]#\n#{data['scan_info']['app_path']}\n\n"
    scan_info << "#[ChecksPerformed]#\n#{data['scan_info']['checks_performed'].join(', ')}\n\n"
    scan_info << "#[BrakemanVersion]#\n#{data['scan_info']['brakeman_version']}\n\n"

    # choose a different parent based on the application path?
    @parent.notes.create(
      :author => @author,
      :category => @category,
      :text => scan_info
    )

    @@logger.info{ "#{data['warnings'].count} Warnings\n===========" }

    # Keep a reference to the node holding each warning type
    sorted_warnings = {}

    data['warnings'].each do |warning|
      @@logger.info{ "* [#{warning['warning_type']}] #{warning['message']}" }

      type = warning['warning_type']

      # Check if this is the first time we've found this warning type
      if !sorted_warnings.key?(type)
        # and create a child node to hold any warnings
        sorted_warnings[type] = @parent.children.find_or_create_by_label(type)
      end

      node_for_type = sorted_warnings[type]

      warning_info =<<EOW
#[Message]#
#{warning['message']}

#[Confidence]#
#{warning['confidence']}

#[Path]#
#{warning['file']}##{warning['line']}

#[Code]#
bc.. #{warning['code']}

#[References]#
#{warning['link']}
EOW

      node_for_type.notes.create(
        :author => @author,
        :category => @category,
        :text => warning_info
      )
    end
  end
end
