require 'spec_helper'

RSpec.describe GitStrategy::LocalCache do
  describe "#synchronize_with_remote" do
    before { Retryable.enable }
    after { Retryable.disable }

    it "should throw an exception after the third fetch attempt" do
      allow(Kochiku::Worker).to receive(:logger) { double('logger', :warn => nil) }
      fetch_double = double('git fetch')
      expect(fetch_double).to receive(:run).exactly(3).times.and_raise(Cocaine::ExitStatusError)
      expect(Cocaine::CommandLine).to receive(:new).with('git fetch', anything).and_return(fetch_double).exactly(3).times

      expect { GitStrategy::LocalCache.send(:synchronize_with_remote, "master") }.to raise_error(Cocaine::ExitStatusError)
    end
  end
end
