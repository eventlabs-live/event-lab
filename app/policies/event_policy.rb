class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def edit?
    user_is_organizer_or_admin?
  end

  def edit_status?
    user_is_organizer_or_admin?
  end

  def update?
    user_is_organizer_or_admin?
  end

  def update_status?
    user_is_organizer_or_admin?
  end

  def destroy?
    user_is_organizer_or_admin?
  end

  private

  def user_is_organizer_or_admin?
    record.organizer_id == user.id || user.admin?
  end

end