module PermitKermit

  def self.included( klass )
    klass.send :include, InstanceMethods
    klass.send :extend, ClassMethods

    klass.helper_method :permitted?
    klass.before_filter :verify_access!
    klass.rescue_from ActionController::PermissionDenied, with: :permision_denied
    klass.cattr_accessor :permission_denied_route
  end

  module ClassMethods

    def permissions
      @permissions ||= []
    end
    
    def permit(*roles)
      options = roles.extract_options!
      self.permissions << [roles, options.symbolize_keys]
    end

    def base_class
      self.superclass.controller_path == self.controller_path ? self.superclass : self
    end
  end

  module InstanceMethods

    def verify_access!
      self.class.base_class.permissions.each do |roles, opt|
        if opt.has_key?(:only)
          next unless [opt[:only]].flatten.include?(action_name.to_sym)
        end

        if opt.has_key?(:except)
          next if [opt[:except]].flatten.include?(action_name.to_sym)
        end

        unless permitted?(*roles)
          raise ActionController::PermissionDenied
        end
      end
      return true
    end

    def permitted?(*roles)
      role_names = roles.flatten.map(&:to_s)

      common_roles = current_user.role_names & role_names

      common_roles.any?
    end

    def permision_denied
      url = polymorphic_path(permission_denied_route || :root)
      return redirect_to(url, alert: t(:"flash.permision_denied"))
    end
  end
end

module ActionController
  class PermissionDenied < ActionControllerError
  end
end
