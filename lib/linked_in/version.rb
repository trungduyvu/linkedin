module LinkedIn

  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 3
    PATCH = 8
    PRE   = 'beta3'
    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join('.')
  end

end
