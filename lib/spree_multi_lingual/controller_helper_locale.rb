module SpreeMultiLingual::ControllerHelperLocale
  extend ActiveSupport::Concern

  included do |base|
    # only way to make sure that set_user_language included by spree_auth_devise controller is overriden correctly
    base.class_eval do
      private

      # Internal : Set user I18n.locale
      #
      # override spree_core set_user_language
      # initialize user language :
      #  params[:locale] is explicitly given by routing-filter /:locale
      # or the session[:locale] set by Spree::LocaleController#set
      # or I18n.locale set by rack-locale for example
      # or Spree::Config[:default_locale]
      # or Rails.application.config.i18n.default_locale
      def set_user_language
        locale = params[:locale] || session[:locale] || I18n.locale || Rails.application.config.i18n.default_locale
        locale = I18n.default_locale unless locale && I18n.available_locales.include?(locale.to_sym)
        I18n.locale = locale.to_sym
      end
    end
  end

end