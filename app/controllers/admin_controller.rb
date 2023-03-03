class AdminController < AuthenticatedUserController
  http_basic_authenticate_with name: Rails.application.credentials.admin_username, password: Rails.application.credentials.admin_password

end
