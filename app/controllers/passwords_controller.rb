class PasswordsController < Devise::PasswordsController
  prepend_before_action :require_no_authentication, only: [:cancel ]

end