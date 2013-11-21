require 'spec_helper'

describe PGInvalidStatement do
  let(:exception_msg) do
    %q{PG::ExclusionViolation: ERROR:  conflicting key value violates exclusion constraint "time_entries_user_id_period_excl"
DETAIL:  Key (user_id, period)=(2, ["2013-11-21 17:10:59+00","2013-11-21 18:10:59+00"]) conflicts with existing key (user_id, period)=(2, ["2013-11-21 16:08:55+00","2013-11-21 18:08:55+00"]).
: UPDATE "time_entries" SET "user_id" = $1 WHERE "time_entries"."id" = 2}
  end

  subject(:exception) { PGInvalidStatement.new(exception_msg) }

  it { expect(exception.name).to eq("PG::ExclusionViolation")}
  it { expect(exception.error).to eq(%q{conflicting key value violates exclusion constraint "time_entries_user_id_period_excl"})}
  it { expect(exception.detail).to eq(%q{Key (user_id, period)=(2, ["2013-11-21 17:10:59+00","2013-11-21 18:10:59+00"]) conflicts with existing key (user_id, period)=(2, ["2013-11-21 16:08:55+00","2013-11-21 18:08:55+00"]).})}
  it { expect(exception.statement).to eq(%q{UPDATE "time_entries" SET "user_id" = $1 WHERE "time_entries"."id" = 2})}
end