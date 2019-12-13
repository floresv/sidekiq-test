class PriorityTest < ActiveJob::Base
  def self.log(level, sleep_for = 3)
    msg = "priority-test: #{level} thing happened"
    Rails.logger.info(msg)
    puts msg
    sleep sleep_for
  end
end
