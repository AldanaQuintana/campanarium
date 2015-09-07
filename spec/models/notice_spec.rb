require 'spec_helper'

describe Notice do
  subject(:notice){ notice_group.notices.first }

  context "when a notice of a group with several notices" do
    let!(:notice_group){ create(:notice_group) }
    describe "is destroyed" do
      it do
        should_not_destroy_its_group do
          notice.destroy
        end
      end
    end

    describe "is unlinked" do
      it do
        should_not_destroy_its_group do
          notice.unlink!
        end
      end
    end

    def should_not_destroy_its_group(&block)
      expect{ yield }.not_to change(NoticeGroup, :count)
    end
  end

  context "when a notice of a group with no more notices" do
    let!(:notice_group){ create(:notice_group, notices_count: 1)}
    describe "is destroyed" do
      it do
        should_destroy_its_group do
          notice.destroy
        end
      end
    end

    describe "is unlinked" do
      it do
        should_destroy_its_group do
          notice.unlink!
        end
      end
    end

    def should_destroy_its_group(&block)
      expect{ yield }.to change(NoticeGroup, :count).by(-1)
    end
  end

  describe "unlink!" do
    let!(:notice_group){ create(:notice_group)}
    before do
      notice.unlink!
    end

    it do
      expect(notice.reload.notice_group).to be_nil
    end
  end
end
