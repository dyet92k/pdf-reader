# coding: utf-8

require File.dirname(__FILE__) + "/spec_helper"

describe PDF::Reader, "column specs" do

  context "page 1" do
    it "should correctly extract the headline" do
      filename = pdf_spec_file("column_integration")

      PDF::Reader.open(filename) do |reader|
        page = reader.page(1)
        page.text.should =~ /Some Headline/
      end
    end
    it "should correctly extract the first few lines" do
      filename = pdf_spec_file("column_integration")

      PDF::Reader.open(filename) do |reader|
        page = reader.page(1)
        ft = page.text
        ft.should =~ /ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu/
        ft.should =~ /Lorem ipsum dolor sit amet, consectetur adipisic -\s+adipisicing elit, sed do eiusmod tempor incididunt/
        ft.should =~ /ing elit, sed do eiusmod tempor incididunt ut labore\s+ut labore et dolore magna aliqua. Ut enim ad minim/
        ft.should =~ /et dolore magna aliqua. Ut enim ad minim veniam,\s+veniam, quis nostrud exercitation ullamco laboris/
        ft.should =~ /quis nostrud exercitation ullamco laboris nisi ut\s+nisi ut aliquip ex ea commodo consequat. Duis aute/
        ft.should =~ /aliquip ex ea commodo consequat. Duis aute irure\s+irure dolor in reprehenderit in voluptate velit esse/
      end
    end

    it "should align text from the second column" do
      filename = pdf_spec_file("column_integration")

      PDF::Reader.open(filename) do |reader|
        page = reader.page(1)
        ft = page.text
        # The following lines are in the second column, and their position with in the
        # string (from the left) should all be at the same spot
        match_pos_1 = find_position_of_match(ft, /adipisicing elit, sed do eiusmod tempor incididunt$/)
        match_pos_2 = find_position_of_match(ft, /ut labore et dolore magna aliqua. Ut enim ad minim$/)
        match_pos_3 = find_position_of_match(ft, /veniam, quis nostrud exercitation ullamco laboris$/)
        match_pos_4 = find_position_of_match(ft, /nisi ut aliquip ex ea commodo consequat. Duis aute$/)
        match_pos_5 = find_position_of_match(ft, /irure dolor in reprehenderit in voluptate velit esse$/)

        match_pos_1.should_not be_nil
        match_pos_1.should eql(match_pos_2)
        match_pos_1.should eql(match_pos_3)
        match_pos_1.should eql(match_pos_4)
        match_pos_1.should eql(match_pos_5)
      end
    end
  end

  context "page 2" do
    it "should correctly align text in column 1" do
      filename = pdf_spec_file("column_integration")

      PDF::Reader.open(filename) do |reader|
        ft = reader.page(2).text

        # The following lines are in the first column of the page prior to the interruption
        col1_1   = find_position_of_match(ft, /^tate velit esse cillum dolore eu/)
        col1_2   = find_position_of_match(ft, /^fugiat nulla pariatur. Excepteur/)
        col1_3   = find_position_of_match(ft, /^sint occaecat cupidatat non proi -/)
        col1_4   = find_position_of_match(ft, /^dent, sunt in culpa qui officia de-/)

        col1_1.should_not be_nil
        col1_1.should eql(col1_2)
        col1_1.should eql(col1_3)
        col1_1.should eql(col1_4)
      end
    end
    it "should correctly align text in column 2" do
      filename = pdf_spec_file("column_integration")

      PDF::Reader.open(filename) do |reader|
        ft = reader.page(2).text

        # The following lines are in the second column of the page prior to the interruption
        col2_1   = find_position_of_match(ft, /occaecat cupidatat non proident,\s*anim/)
        col2_2   = find_position_of_match(ft, /sunt in culpa qui officia deserunt\s*sum/)
        col2_3   = find_position_of_match(ft, /mollit anim id est laborum. Lo -\s*adipisicing/)
        col2_4   = find_position_of_match(ft, /rem ipsum dolor sit amet, con -\s*tempor/)

        col2_1.should_not be_nil
        col2_1.should eql(col2_2)
        col2_1.should eql(col2_3)
        col2_1.should eql(col2_4)
      end
    end

    it "should correctly align text in column 3 before the interruption" do
      filename = pdf_spec_file("column_integration")

      PDF::Reader.open(filename) do |reader|
        ft = reader.page(2).text

        # The following lines are in the third column of the page prior to the interruption
        col3_a_1 = find_position_of_match(ft, /anim id est laborum. Lorem ip -$/)
        col3_a_2 = find_position_of_match(ft, /sum dolor sit amet, consectetur$/)
        col3_a_3 = find_position_of_match(ft, /adipisicing elit, sed do eiusmod$/)
        col3_a_4 = find_position_of_match(ft, /tempor incididunt ut labore et$/)

        col3_a_1.should_not be_nil
        col3_a_1.should eql(col3_a_2)
        col3_a_1.should eql(col3_a_3)
        col3_a_1.should eql(col3_a_4)
      end
    end

    it "should correctly align text in column 3 during the interruption" do
      filename = pdf_spec_file("column_integration")

      PDF::Reader.open(filename) do |reader|
        ft = reader.page(2).text

        #the following lines are in the third column of the page _during_ the interruption
        col3_b_1 = find_position_of_match(ft, /\s{10}dolore magna aliqua. Ut$/)
        col3_b_2 = find_position_of_match(ft, /\s{10}enim ad minim veniam,$/)
        col3_b_3 = find_position_of_match(ft, /\s{10}quis nostrud exercitation$/)
        col3_b_4 = find_position_of_match(ft, /\s{10}ullamco laboris nisi ut$/)

        col3_b_1.should_not be_nil
        col3_b_1.should eql(col3_b_2)
        col3_b_1.should eql(col3_b_3)
        col3_b_1.should eql(col3_b_4)
      end
    end
  end

  def find_position_of_match(source, regex)
    source.each_line do |line|
      if x_pos = line =~ regex
        return x_pos
      end
    end
    nil
  end

end
