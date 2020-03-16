module Avram::SoftDelete::Query
  def only_kept
    soft_deleted_at.is_nil
  end

  def only_soft_deleted
    soft_deleted_at.is_not_nil
  end
end
