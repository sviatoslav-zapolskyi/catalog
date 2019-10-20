class BookPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def scrap_from_fantlab?
    admin?
  end
end
