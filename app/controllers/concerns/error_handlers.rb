module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from Exception,                                with: :rescue500
    rescue_from ApplicationController::Forbidden,         with: :rescue403
    rescue_from ApplicationController::IpAddressRejected, with: :rescue403
    rescue_from Pundit::NotAuthorizedError,               with: :rescue403
    rescue_from ActionController::RoutingError,           with: :rescue404
    rescue_from ActiveRecord::RecordNotFound,             with: :rescue404
  end

  private

  def rescue403(exception)
    @exception = exception
    render 'errors/403', status: :forbidden
  end

  def rescue404(exception)
    @exception = exception
    render 'errors/404', status: :not_found
  end

  def rescue500(exception)
    @exception = exception
    render '/errors/500', status: :internal_server_error
  end
end
