module LockableConcern
  extend ActiveSupport::Concern

  included do
    scope :locked, ->(is_locked:) {
      if is_locked
        where.not(locked_at: nil)
      else
        where(locked_at: nil)
      end
    }

    def lock
      assign_attributes(locked_at: Time.current)
    end

    def unlock
      assign_attributes(locked_at: nil)
    end

    def locked?
      locked_at.present?
    end

    def unlocked?
      locked_at.blank?
    end
  end
end
