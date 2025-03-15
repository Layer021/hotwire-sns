# frozen_string_literal: true

class User::Auth::SessionsController < Devise::SessionsController
  layout 'user/auth'
end
