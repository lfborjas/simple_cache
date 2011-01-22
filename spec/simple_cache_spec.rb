require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "SimpleCache" do

  before :each do
      @timeout = 5 #seconds
      @max_size= 16 #bytes
      @store = SimpleCache::MemoryCache.new :timeout => @timeout, :max_size=> @max_size
  end

  it "should store a value" do
      @store["foo"] = "bar"
      @store.has_key?("foo").should == true
      @store.cache_size.should == "bar".size
  end

  it "should retrieve a value" do
    @store["foo"] = "bar"
    @store["foo"].should == "bar"
  end

  it "should assert the presence of keys" do
      @store["foo"] = "bar"
      @store.has_key?("foo").should == true
  end

  it "should prune the cache based on size" do
    @store["first"]  = "z"*4
    @store["second"] = "y"*4
    @store["third"]  = "x"*4
    @store["fourth"] = "b"*4
    @store["fifth"] =  "a"*4

    @store.cache_size.should == 12

    %w{fifth fourth third}.each do |key|
        @store.has_key?(key).should == true
    end

    %w{first second}.each do |key|
        @store.has_key?(key).should == false
    end

  end
  
  it "should prune the cache based on time" do 
    @store["first"]  = "z"*4
    @store["second"] = "y"*4
    @store["third"]  = "n"*4

    sleep @timeout+2

    @store["third"] = "x"*4
    @store["fourth"] = "a"*5

    @store.cache_size.should == 9

    %w{fourth third}.each do |key|
        @store.has_key?(key).should == true
    end
    
    %w{first second}.each do |key|
        @store.has_key?(key).should == false
    end

  end

end
