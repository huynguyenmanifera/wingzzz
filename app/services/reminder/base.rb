module Reminder
  class Base
    def call
      log description do
        target_audience.find_each { |user| remind(user) }
      end
    end

    protected

    def description; end

    def target_audience
      User.none
    end

    def message(user); end

    private

    def remind(user)
      log "Sending email to #{user.email}."
      #   # Since this is called from a Heroku scheduler, we cannot use `deliver_later` here.
      #   # We also make sure no errors are raised (hence the '!').
      message(user).deliver_now!
    end

    def log(msg)
      if block_given?
        log "Start: #{msg}"
        yield
        log "Done: #{msg}"
      else
        logger.tagged(self.class.name) { logger.info { msg } }
      end
    end

    def logger
      Rails.logger
    end
  end
end
