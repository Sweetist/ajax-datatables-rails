require 'spec_helper'

describe AjaxDatatablesRails::ORM::ActiveRecord do

  let(:view) { double('view', params: sample_params) }
  let(:datatable) { SampleDatatable.new(view) }
  let(:records) { User.all }

  before(:each) do
    create(:user, username: 'johndoe', email: 'johndoe@example.com')
    create(:user, username: 'msmith', email: 'mary.smith@example.com')
  end

  describe '#paginate_records' do
    it 'requires a records collection argument' do
      expect { datatable.paginate_records }.to raise_error(ArgumentError)
    end

    it 'paginates records properly' do
      expect(datatable.paginate_records(records).to_sql).to include(
        'LIMIT 10 OFFSET 0'
      )

      datatable.params[:start] = '26'
      datatable.params[:length] = '25'
      expect(datatable.paginate_records(records).to_sql).to include(
        'LIMIT 25 OFFSET 25'
      )
    end

    it 'depends on the value of #offset' do
      expect(datatable.datatable).to receive(:offset)
      datatable.paginate_records(records)
    end

    it 'depends on the value of #per_page' do
      expect(datatable.datatable).to receive(:per_page).at_least(:once) { 10 }
      datatable.paginate_records(records)
    end
  end

end
