require "./spec_helper"

class SoftDeletableItemQuery < SoftDeletableItem::BaseQuery
  include Avram::SoftDelete::Query
end

describe "Avram soft delete" do
  describe "models" do
    it "allows soft deleting a record" do
      item = SoftDeletableItemBox.create &.kept

      item = item.soft_delete

      item.soft_deleted_at.should_not be_nil
    end

    it "allows restoring a soft deleted record" do
      item = SoftDeletableItemBox.create &.soft_deleted

      item = item.restore

      item.soft_deleted_at.should be_nil
    end

    it "allows checking if a record is soft deleted" do
      item = SoftDeletableItemBox.create &.kept
      item.soft_deleted?.should be_false

      item = item.soft_delete

      item.soft_deleted?.should be_true
    end
  end

  describe "queries" do
    it "can get only kept records" do
      kept_item = SoftDeletableItemBox.create &.kept
      SoftDeletableItemBox.create &.soft_deleted

      SoftDeletableItemQuery.new.only_kept.results.should eq([
        kept_item,
      ])
    end

    it "can get only soft deleted records" do
      SoftDeletableItemBox.create &.kept
      soft_deleted_item = SoftDeletableItemBox.create &.soft_deleted

      SoftDeletableItemQuery.new.only_soft_deleted.results.should eq([
        soft_deleted_item,
      ])
    end

    # Waiting on https://github.com/luckyframework/avram/issues/319
    # 'with_soft_deleted' would do `.reset_where(&.soft_deleted)`
    pending "can get soft deleted and kept records" do
      kept_item = SoftDeletableItemBox.create &.kept
      soft_deleted_item = SoftDeletableItemBox.create &.soft_deleted

      SoftDeletableItemQuery.new.only_kept.with_soft_deleted.results.should eq([
        kept_item,
        soft_deleted_item,
      ])
    end

    # Waiting on: https://github.com/luckyframework/avram/issues/322
    pending "can bulk soft delete" do
      kept_item = SoftDeletableItemBox.create &.kept

      SoftDeletableItemQuery.new.soft_delete

      reload(kept_item).soft_deleted?.should be_true
    end

    # Waiting on: https://github.com/luckyframework/avram/issues/322
    pending "can bulk restore" do
      soft_deleted_item = SoftDeletableItemBox.create &.soft_deleted

      SoftDeletableItemQuery.new.restore

      reload(soft_deleted_item).soft_deleted?.should be_false
    end
  end
end

private def reload(item)
  SoftDeletableItemQuery.find(item.id)
end
