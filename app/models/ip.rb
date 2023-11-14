class Ip < Sequel::Model
  plugin :validation_helpers

  def before_validation
    super
    set_ip_version if new?
  end

  def validate
    super
    validates_presence :address
    validates_presence :enabled
    validates_includes %w[ipv4 ipv6], :ip_version
  end

  def set_ip_version
    self.ip_version = if address =~ /^(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}$/
                   'ipv4'
                 elsif address =~ /^((?:[0-9A-Fa-f]{1,4}))((?::[0-9A-Fa-f]{1,4}))*::((?:[0-9A-Fa-f]{1,4})) \
                                  ((?::[0-9A-Fa-f]{1,4}))*|((?:[0-9A-Fa-f]{1,4}))((?::[0-9A-Fa-f]{1,4})){7}$/
                   'ipv6'
                 end
  end
end
