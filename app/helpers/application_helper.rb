module ApplicationHelper
  def user_is_admin?
    user_signed_in? && current_user.has_role?(:admin)
  end

  def toast_klass(flash_message_klass)
    case flash_message_klass.to_sym
    when :alert
      "toast align-items-center bg-danger border-0"
    else
      "toast align-items-center bg-success border-0"
    end
  end
end
