require 'rails_helper'

RSpec.describe Reminder do
  describe 'last day of trial' do
    describe 'for users' do
      it 'should only mail to users without a subscription' do
        user_without_subscription = create(:user, :on_last_day_of_trial)

        # these shouldn't be included
        create(:user, trial: build(:trial, expires_after: Date.current - 1.day))
        create(:user, trial: build(:trial, expires_after: Date.current + 1.day))
        create(:user, :with_an_active_subscription, :on_last_day_of_trial)
        create(:user, :teacher, :on_last_day_of_trial)
        create(
          :user,
          :teacher,
          :with_a_school_subscription,
          :on_last_day_of_trial
        )
        create(
          :user,
          :teacher,
          :with_an_active_subscription,
          :on_last_day_of_trial
        )

        reminder = Reminder::LastDayOfTrial.new

        expect(reminder.send(:target_audience)).to contain_exactly(
          user_without_subscription
        )
      end
    end

    describe 'for teachers' do
      it 'should only mail to teachers without a subscription' do
        teacher_without_subscription =
          create(:user, :teacher, :on_last_day_of_trial)

        # these shouldn't be included
        create(
          :user,
          :teacher,
          trial: build(:trial, expires_after: Date.current - 1.day)
        )
        create(
          :user,
          :teacher,
          trial: build(:trial, expires_after: Date.current + 1.day)
        )
        create(:user, :on_last_day_of_trial)
        create(:user, :with_an_active_subscription, :on_last_day_of_trial)
        create(
          :user,
          :teacher,
          :with_a_school_subscription,
          :on_last_day_of_trial
        )
        create(
          :user,
          :teacher,
          :with_an_active_subscription,
          :on_last_day_of_trial
        )

        reminder = Reminder::LastDayOfTrialForTeachers.new

        expect(reminder.send(:target_audience)).to contain_exactly(
          teacher_without_subscription
        )
      end
    end
  end

  describe 'trial expired' do
    let(:days_after_trial) { 3 }

    describe 'for users' do
      it 'should only mail to users without a subscription' do
        user_without_subscription =
          create(
            :user,
            trial: build(:trial, expires_after: days_after_trial.days.ago)
          )

        # these shouldn't be included
        create(
          :user,
          trial: build(:trial, expires_after: days_after_trial.days.ago - 1.day)
        )
        create(
          :user,
          trial: build(:trial, expires_after: days_after_trial.days.ago + 1.day)
        )
        create(
          :user,
          :with_an_active_subscription,
          trial: build(:trial, expires_after: days_after_trial.days.ago)
        )
        create(
          :user,
          :teacher,
          trial: build(:trial, expires_after: days_after_trial.days.ago)
        )
        create(
          :user,
          :teacher,
          trial: build(:trial, expires_after: days_after_trial.days.ago)
        )
        create(
          :user,
          :teacher,
          trial: build(:trial, expires_after: days_after_trial.days.ago)
        )

        reminder = Reminder::TrialEnded.new

        expect(reminder.send(:target_audience)).to contain_exactly(
          user_without_subscription
        )
      end
    end

    describe 'for teachers' do
      it 'should only mail to teachers without a subscription' do
        teacher_without_subscription =
          create(
            :user,
            :teacher,
            trial: build(:trial, expires_after: days_after_trial.days.ago)
          )

        # these shouldn't be included
        create(
          :user,
          :teacher,
          trial: build(:trial, expires_after: days_after_trial.days.ago - 1.day)
        )
        create(
          :user,
          :teacher,
          trial: build(:trial, expires_after: days_after_trial.days.ago + 1.day)
        )
        create(
          :user,
          trial: build(:trial, expires_after: days_after_trial.days.ago)
        )
        create(
          :user,
          :teacher,
          :with_a_school_subscription,
          trial: build(:trial, expires_after: days_after_trial.days.ago),
          email: 'test@example.com'
        )
        create(
          :user,
          :teacher,
          :with_an_active_subscription,
          trial: build(:trial, expires_after: days_after_trial.days.ago)
        )

        reminder = Reminder::TrialEndedForTeachers.new

        expect(reminder.send(:target_audience)).to contain_exactly(
          teacher_without_subscription
        )
      end
    end
  end
end
