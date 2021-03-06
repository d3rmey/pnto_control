class MongoModel::Closure
  include Mongoid::Document

  store_in collection: "closures"

  field :start_date, type: Date
  field :end_date, type: Date

  belongs_to :account, class_name: MongoModel::Account.to_s

  validates_presence_of :start_date, :end_date

  validates_uniqueness_of :start_date, :end_date, scope: :account_id

  default_scope -> { desc(:end_date) }

  def balance
    account.day_records.where(reference_date: start_date..end_date).
    inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
  end
end
