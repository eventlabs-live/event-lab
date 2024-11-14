module ApplicationHelper
  def device_type
    browser = Browser.new(request.user_agent)
    if browser.device.mobile?
      :mobile
    elsif browser.device.tablet?
      :tablet
    else
      :desktop
    end
  end
end
