module BrakemanUpload  
  module Meta
    NAME = "Brakeman Static Analysis output (.json) upload"
    EXPECTS = "Expects Brakeman JSON output, use: brakeman -f json -o results.json"
    # change this to the appropriate version
    module VERSION #:nodoc:
      MAJOR = 2
      MINOR = 10
      TINY = 0

      STRING = [MAJOR, MINOR, TINY].join('.')
    end
  end
end
