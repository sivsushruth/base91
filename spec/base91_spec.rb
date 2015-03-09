require 'spec_helper'
describe Base91 do
	it "encodes string" do
    expect(Base91.encode("base91 is much better than basE64")).to eq("[D7ghoHBt#6tF9}iNBMf>[!eKUd/<P:m~FH<<w#XD")
  end

  it "encodes string with all standard characters" do
    expect(Base91.encode("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890,./;'[]-=<>?:\"{}_+!@#\{$%^&*\(\)\}")).to eq("#G(Ic,5ph#77&xrmlrjgs@DZ7UB>xQGrfG^F%w_o%5qOdwQbFrzd[5eYAP;gMP+fQztEml0o[2;(p*1QfUve]f>){3_[XjLs\"f^C.YTZwG}1=BrOiB")
  end

  it "decodes data to produce original string" do
    expect(Base91.decode("[D7ghoHBt#6tF9}iNBMf>[!eKUd/<P:m~FH<<w#XD")).to eq("base91 is much better than basE64")
  end

  it "encodes data to produce string with all standard characters" do
    expect(Base91.decode("#G(Ic,5ph#77&xrmlrjgs@DZ7UB>xQGrfG^F%w_o%5qOdwQbFrzd[5eYAP;gMP+fQztEml0o[2;(p*1QfUve]f>){3_[XjLs\"f^C.YTZwG}1=BrOiB")).to eq("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890,./;'[]-=<>?:\"{}_+!@#\{$%^&*\(\)\}")
  end
end