module Avram::SoftDelete::Model
  def soft_delete : self
    save_operation_class.update!(self, soft_deleted_at: Time.utc)
  end

  def restore : self
    save_operation_class.update!(self, soft_deleted_at: nil)
  end

  abstract def save_operation_class

  def soft_deleted? : Bool
    !!soft_deleted_at
  end
end
