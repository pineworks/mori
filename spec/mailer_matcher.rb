# Usage
#   order = create(:order)
#
#   expect {
#      order.pay!
#    }.to deliver_email(OrderMailer, :paid, order.id)
#
#
 
 
RSpec::Matchers.define :deliver_email do |mailer, action, *args|
  match do |block|
    stubbed_mailer = double('mailer', deliver: true)
    mailer.stub(action => stubbed_mailer)
 
    block.call
 
    expect(mailer).to have_received(action).with(*args)
    expect(stubbed_mailer).to have_received(:deliver)
  end
 
  failure_message_for_should do |actual|
    "expected that block would deliver #{mailer}##{:action}"
  end
 
  failure_message_for_should_not do |actual|
    "expected that block would not deliver #{mailer}##{:action}"
  end
 
  description do
    "deliver #{mailer}##{:action}"
  end
end
