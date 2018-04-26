require 'spec_helper'

describe ValidationRules do
  context 'alpha' do
    it 'passes for valid characters' do
      ValidationRules.alpha('A').should be_true
      ValidationRules.alpha('ABCDEFGHIJKLMNOPQRSTUVWXYZ').should be_true
      ValidationRules.alpha('abcdefghijklmnopqrstuvwxyz').should be_true
    end

    it 'fails for invalid characters' do
      ValidationRules.alpha('1234567890').should be_false
      ValidationRules.alpha('ABC123').should be_false
      ValidationRules.alpha('AB_').should be_false
      ValidationRules.alpha('&^%@#').should be_false
    end
  end

  context 'alpha_dash' do
    it 'passes for valid characters' do
      ValidationRules.alpha_dash('ABCDEFGHIJKLMNOPQRSTUVWXYZ').should be_true
      ValidationRules.alpha_dash('abcdefghijklmnopqrstuvwxyz').should be_true
      ValidationRules.alpha_dash('ABC-_').should be_true
      ValidationRules.alpha_dash('ABCabc_-').should be_true
    end

    it 'fails for invalid characters' do
      ValidationRules.alpha_dash('1234567890').should be_false
      ValidationRules.alpha_dash('12345_-').should be_false
      ValidationRules.alpha_dash('ABC_-%^&#').should be_false
    end
  end

  context 'alpha_dash_digit' do
    it 'passes for valid characters' do
      ValidationRules.alpha_dash_digit('Aa-_0').should be_true
      ValidationRules.alpha_dash_digit('_-_').should be_true
    end

    it 'fails for invalid characters' do
      ValidationRules.alpha_dash_digit('ABCa-&%$').should be_false
      ValidationRules.alpha_dash_digit('%^&*&(*\$#').should be_false
      ValidationRules.alpha_dash_digit('ASbVN\_').should be_false
    end
  end

  context 'alpha_dash_slash' do
    it 'passes for valid characters' do
      ValidationRules.alpha_dash_slash('ABCDEFGHIJKLMNOPQRSTUVWXYZ').should be_true
      ValidationRules.alpha_dash_slash('abcdefghijklmnopqrstuvwxyz').should be_true
      ValidationRules.alpha_dash_slash('ABC-_/').should be_true
      ValidationRules.alpha_dash_slash('ABCabc_-/').should be_true
    end

    it 'fails for invalid characters' do
      ValidationRules.alpha_dash_slash('1234567890').should be_false
      ValidationRules.alpha_dash_slash('12345_-/').should be_false
      ValidationRules.alpha_dash_slash('ABC_-%^&#/').should be_false
    end
  end

  context 'alpha_numeric' do
    it 'passes for valid characters' do
      ValidationRules.alpha_numeric('ABCDEFGHIJKLMNOPQRSTUVWXYZ').should be_true
      ValidationRules.alpha_numeric('abcdefghijklmnopqrstuvwxyz').should be_true
      ValidationRules.alpha_numeric('1234567890').should be_true
      ValidationRules.alpha_numeric('ABCDabc1234').should be_true
    end

    it 'fails for invalid characters' do
      ValidationRules.alpha_numeric('ABC_-/').should be_false
    end
  end

  context 'alpha_numeric_dash_regex' do
    it 'passes for valid characters' do
      ValidationRules.alpha_numeric_dash('ABCDEFGHIJKLMNOPQRSTUVWXYZ').should be_true
      ValidationRules.alpha_numeric_dash('abcdefghijklmnopqrstuvwxyz').should be_true
      ValidationRules.alpha_numeric_dash('A-B-C-0-9').should be_true
      ValidationRules.alpha_numeric_dash('A_B_C_0_9').should be_true
      ValidationRules.alpha_numeric_dash('A_-B_-C_-0_-9').should be_true
    end

    it 'fails for invalid characters' do
      ValidationRules.alpha_numeric_dash('ABC/').should be_false
      ValidationRules.alpha_numeric_dash('ABC&*^$#').should be_false
    end
  end

  context 'decimal' do
    it 'passes for valid numbers' do
      ValidationRules.decimal(1).should be_true
      ValidationRules.decimal('1').should be_true
      ValidationRules.decimal('-1.0').should be_true
      ValidationRules.decimal(-1.0).should be_true
      ValidationRules.decimal(+1.0).should be_true
      ValidationRules.decimal('+99.99').should be_true
      ValidationRules.decimal('99.99').should be_true
      ValidationRules.decimal(99.99).should be_true
      ValidationRules.decimal('999.99').should be_true # check for precision
      ValidationRules.decimal('9.99', 3, 2).should be_true # check for precision
      ValidationRules.decimal('99.99', 4, 2).should be_true # check for precision
      ValidationRules.decimal('9.999', 4, 3).should be_true # check for precision
      ValidationRules.decimal('9.9', 4, 3).should be_true # check for precision
      ValidationRules.decimal('.99').should be_true
    end

    it 'failes for invalid numbers' do
      ValidationRules.decimal('sfdsf').should be_false
      ValidationRules.decimal('aa.bb').should be_false
      ValidationRules.decimal('99.99.99').should be_false
      ValidationRules.decimal('9999.9').should be_false
      ValidationRules.decimal('9.999', 4, 2).should be_false
    end
  end

  context 'email' do
    it 'passes for valid addresses' do
      ValidationRules.email('name@domain.com').should be_true
      ValidationRules.email('name2@domain.com').should be_true
      ValidationRules.email('l3tt3rsAndNumb3rs@domain.com').should be_true
      ValidationRules.email('has-dash@domain.com').should be_true
      ValidationRules.email('hasApostrophe.o\'leary@domain.org').should be_true
      ValidationRules.email('uncommonTLD@domain.museum').should be_true
      ValidationRules.email('uncommonTLD@domain.travel').should be_true
      ValidationRules.email('uncommonTLD@domain.mobi').should be_true
      ValidationRules.email('countryCodeTLD@domain.uk').should be_true
      ValidationRules.email('countryCodeTLD@domain.rw').should be_true
      ValidationRules.email('lettersInDomain@911.com').should be_true
      ValidationRules.email('underscore_inLocal@domain.net').should be_true
      ValidationRules.email('subdomain@sub.domain.com').should be_true
      ValidationRules.email('local@dash-inDomain.com').should be_true
      ValidationRules.email('dot.inLocal@foo.com').should be_true
      ValidationRules.email('a@singleLetterLocal.org').should be_true
      ValidationRules.email('singleLetterDomain@x.org').should be_true
      ValidationRules.email('&*=?^+{}\'~@validCharsInLocal.net').should be_true
      ValidationRules.email('TLDDoesntExist@domain.moc').should be_true
      ValidationRules.email('numbersInTLD@domain.c0m').should be_true
    end

    it 'fails for invalid addresses' do
      ValidationRules.email('IPInsteadOfDomain@127.0.0.1').should be_false
      ValidationRules.email('IPAndPort@127.0.0.1:25').should be_false
      ValidationRules.email('missingDomain@.com').should be_false
      ValidationRules.email('@missingLocal.org').should be_false
      ValidationRules.email('missingatSign.net').should be_false
      ValidationRules.email('missingDot@com').should be_false
      ValidationRules.email('two@@signs.com').should be_false
      ValidationRules.email('colonButNoPort@127.0.0.1:').should be_false
      ValidationRules.email('someone-else@127.0.0.1.26').should be_false
      ValidationRules.email('.localStartsWithDot@domain.com').should be_false
      ValidationRules.email('localEndsWithDot.@domain.com').should be_false
      ValidationRules.email('two..consecutiveDots@domain.com').should be_false
      ValidationRules.email('domainStartsWithDash@-domain.com').should be_false
      ValidationRules.email('domainEndsWithDash@domain-.com').should be_false
      ValidationRules.email('missingTLD@domain.').should be_false
      ValidationRules.email('! "#$%(),/;<>[]`|@invalidCharsInLocal.org').should be_false
      ValidationRules.email('invalidCharsInDomain@! "#$%(),/;<>_[]`|.org').should be_false
      ValidationRules.email('local@SecondLevelDomainNamesAreInvalidIfTheyAreLongerThan64Charactersss.org').should be_false
    end
  end

  context 'money' do
    it 'passes for valid values' do
      ValidationRules.money('5.55').should be_true
      ValidationRules.money('55.55').should be_true
      ValidationRules.money(5.55).should be_true
      ValidationRules.money('5.55', 4).should be_true
      ValidationRules.money('5.555', 4).should be_true
      ValidationRules.money('5.5555', 4).should be_true
      ValidationRules.money('-5').should be_true
      ValidationRules.money('+5').should be_true
      ValidationRules.money(-5).should be_true
      ValidationRules.money(+5).should be_true
      ValidationRules.money('.98').should be_true
    end

    it 'fails for invalid values' do
      ValidationRules.money('asdf').should be_false
      ValidationRules.money('55.555', 2).should be_false
    end
  end

  it 'validates length' do
    ValidationRules.length('123456', 6).should be_true
    ValidationRules.length(123456, 6).should be_true

    ValidationRules.length('12345', 6).should be_false
    ValidationRules.length('12345', 4).should be_false
  end

  it 'validates matches' do
    ValidationRules.matches('ABC', 'ABC').should be_true
    ValidationRules.matches('abc', 'abc').should be_true

    ValidationRules.matches('abc', 'ABC').should be_false
    ValidationRules.matches('abc', 'fgh').should be_false
  end

  it 'validates max_length' do
    ValidationRules.max_length('abcd', 4).should be_true
    ValidationRules.max_length('abcd', 10).should be_true

    ValidationRules.max_length('abcd', 3).should be_false
  end

  it 'validates min_length' do
    ValidationRules.min_length('abcd', 4).should be_true
    ValidationRules.min_length('abcde', 3).should be_true

    ValidationRules.min_length('abcde', 10).should be_false
  end

  it 'validates numeric values' do
    ValidationRules.numeric('123456').should be_true
    ValidationRules.numeric(123456).should be_true
    ValidationRules.numeric('10.99').should be_true
    ValidationRules.numeric(10.99).should be_true
    ValidationRules.numeric('5.4e-29').should be_true
    ValidationRules.numeric('12e20').should be_true
    ValidationRules.numeric('0').should be_true
    ValidationRules.numeric(0).should be_true

    ValidationRules.numeric('ABCDS').should be_false
    ValidationRules.numeric('ab123.99').should be_false
  end

  it 'validates numeric_min' do
    ValidationRules.numeric_min('11', '10').should be_true
    ValidationRules.numeric_min(11, 10).should be_true
    ValidationRules.numeric_min(11, 11).should be_true
    ValidationRules.numeric_min(10.99, 10).should be_true

    ValidationRules.numeric_min(40, 50).should be_false
  end

  it 'validates numeric_max' do
    ValidationRules.numeric_max('50', '69').should be_true
    ValidationRules.numeric_max(50, 69).should be_true
    ValidationRules.numeric_max(50, 50).should be_true
    ValidationRules.numeric_max(10.99, 11).should be_true

    ValidationRules.numeric_max(50, 40).should be_false
  end

  it 'validates positive' do
    ValidationRules.positive(10).should be_true
    ValidationRules.positive(10.99).should be_true
    ValidationRules.positive('10.99').should be_true

    ValidationRules.positive('-10.99').should be_false
    ValidationRules.positive(-10.99).should be_false
    ValidationRules.positive(0).should be_false
  end

  it 'validates negative' do
    ValidationRules.negative('-10.99').should be_true
    ValidationRules.negative(-10.99).should be_true

    ValidationRules.negative(10).should be_false
    ValidationRules.negative(10.99).should be_false
    ValidationRules.negative('10.99').should be_false
    ValidationRules.negative(0).should be_false
  end

  it 'validates range' do
    ValidationRules.range(5, 1, 10).should be_true
    ValidationRules.range(5.5, 1, 10).should be_true
    ValidationRules.range('5', '1', '10').should be_true
    ValidationRules.range('5.5', '1', '10').should be_true
    ValidationRules.range(5, 5, 10).should be_true
    ValidationRules.range(10, 1, 10).should be_true

    ValidationRules.range(20, 5, 10).should be_false
    ValidationRules.range(1, 5, 10).should be_false
  end

  it 'validates json' do
    ValidationRules.json('{ "key": "value" }').should be_true

    ValidationRules.json('{ "key: "value" }').should be_false
    ValidationRules.json('no good').should be_false
  end

  it 'validates date' do
    ValidationRules.date('2010-10-25').should be_true

    ValidationRules.date('2010/10/25').should be_false
    ValidationRules.date('10-25-83').should be_false
    ValidationRules.date('10-25-1983').should be_false
    ValidationRules.date('2010-10-25 01:11:59').should be_false
    ValidationRules.date('2010-99-99').should be_false
  end

  it 'validates dates in iso8601' do
    ValidationRules.iso8601('2010-10-25').should be_true
    ValidationRules.iso8601('2010-10-25T00:00:00').should be_true
    ValidationRules.iso8601('2010-10-25T10:00:00.12').should be_true
    ValidationRules.iso8601('2010-10-25T10:00:00+07:00').should be_true
    ValidationRules.iso8601('2010-10-25T10:00:00.12+07:00').should be_true
    ValidationRules.iso8601('2010-10-25T00:00:00Z').should be_true

    ValidationRules.iso8601('2010-10-25 00:00:00').should be_false
    ValidationRules.iso8601('2010-10-25 00:99:00').should be_false
    ValidationRules.iso8601('2010/10/05').should be_false
    ValidationRules.iso8601('2010-99-99').should be_false
  end

  it 'validates future dates' do
    ValidationRules.future_date('2100-10-25').should be_true
    ValidationRules.future_date(Time.now).should be_true

    ValidationRules.future_date('2010-10-25').should be_false
  end

  it 'validates past dates' do
    ValidationRules.past_date('1998-10-25').should be_true
    ValidationRules.past_date(Time.now).should be_true

    ValidationRules.past_date('2100-10-25').should be_false
  end

  describe '.between_dates' do
    it 'validates valid between' do
      ValidationRules.between_dates(Time.now, '2010-10-25', '2100-10-25').should be_true

      ValidationRules.between_dates(Time.now, '2010-10-25', '2011-10-25').should be_false
      ValidationRules.between_dates(Time.now, '2100-10-25', '2120-10-25').should be_false
      ValidationRules.between_dates(Time.now, '2100-10-25', '2011-10-25').should be_false
    end
  end

  subject do
    ValidationRules
  end

  describe '.bool' do
    it 'validates for boolean true' do
      subject.bool(true).should be_true
    end

    it 'validates for boolean false' do
      subject.bool(false).should be_true
    end

    it 'rejects non bool' do
      subject.bool('true').should be_false
      subject.bool('false').should be_false
      subject.bool('1').should be_false
      subject.bool('0').should be_false
      subject.bool('abc').should be_false
      subject.bool(5).should be_false
    end
  end

  describe '.any_bool' do
    it 'validates for boolean true' do
      subject.any_bool(true).should be_true
    end

    it 'validates for any_boolean false' do
      subject.any_bool(false).should be_true
    end

    it 'validates for string true' do
      subject.any_bool('true').should be_true
    end

    it 'validates for string false' do
      subject.any_bool('false').should be_true
    end

    it 'validates for int 1' do
      subject.any_bool(1).should be_true
    end

    it 'validates for int 0' do
      subject.any_bool(0).should be_true
    end

    it 'validates for string 1' do
      subject.any_bool('1').should be_true
    end

    it 'validates for string 0' do
      subject.any_bool('0').should be_true
    end

    it 'rejects non bool' do
      subject.any_bool('5').should be_false
      subject.any_bool('abc').should be_false
      subject.any_bool(5).should be_false
    end
  end

  describe '.url' do
    it 'allows valid urls' do
      subject.url('http://www.example.com').should be_true
      subject.url('http://www.example.com/path').should be_true
      subject.url('http://example.com').should be_true
      subject.url('http://example.com?param=something').should be_true
      subject.url('http://test:test@example.com').should be_true
      subject.url('http://example.co.uk').should be_true
      subject.url('http://example.com:80').should be_true
      subject.url('http://localhost').should be_true
    end

    it 'rejects invalid urls' do
      subject.url('example.com').should be_false
      subject.url('example.com/some path').should be_false
      subject.url('example.com/some%20path').should be_false
      subject.url('http://www.example.com/düsseldorf?x=Lörick').should be_false
    end
  end

  describe '.ip_address' do
    it 'allows valid IP addresses' do
      subject.ip_address('1.1.1.1').should be_true
      subject.ip_address('255.255.255.255').should be_true
    end

    it 'rejects invalud IP addresses' do
      subject.ip_address('localhost').should be_false
      subject.ip_address('a.b.c.d').should be_false
      subject.ip_address('255.255.255.256').should be_false
    end
  end

  describe '.uuid' do
    it 'allows valid UUIDs' do
      subject.uuid('01234567-9ABC-DEF0-1234-56789ABCDEF0').should be_true
    end

    it 'rejects invalid UUIDs' do
      subject.uuid('invalid').should be_false
      subject.uuid('ABCD-EFG-HIJ-KLM-NOP').should be_false
    end
  end
end
