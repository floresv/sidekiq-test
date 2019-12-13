class ApplicationController < ActionController::API
  # i18n configuration. See: http://guides.rubyonrails.org/i18n.html
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: locale }
  end

  # for devise to redirect with locale
  def self.default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

  def index
    queues = [:low, :critical, :default, :high]
    50.times do |i|
      queues.each do |level|
        PriorityTest.sidekiq_delay(queue: level).log("#{i}: #{level}")
      end
    end
    render json: { message: 'Welcome to Rails Bootstrap' }
  end
end
