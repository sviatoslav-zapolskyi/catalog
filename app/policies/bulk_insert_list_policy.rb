class BulkInsertListPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin?
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
end
