require_relative '../plugins/parser_audit.rb'
require 'fluent/test/parser_test'
require 'fluent/parser'

describe Fluent::AuditParser do
  UNPARSED_EVENT = 'type=SYSCALL msg=audit(1488935105.853:413267): arch=c000003e syscall=87 success=yes exit=0 a0=555c8a43f750 a1=555c885ce2e0 a2=7ffc3b104d80 a3=0 items=2 ppid=23256 pid=23288 auid=1003 uid=1003 gid=1004 euid=1003 suid=1003 fsuid=1003 egid=1004 sgid=1004 fsgid=1004 tty=(none) ses=20327 comm="sshd" exe="/usr/sbin/sshd" key="delete"'
  PARSED_EVENT_TIME = 1488935105
  PARSED_EVENT_RECORD = {
    'type' => 'SYSCALL',
    'arch' => 'c000003e',
    'syscall' => '87',
    'success' => 'yes',
    'exit' => '0',
    'a0' => '555c8a43f750',
    'a1' => '555c885ce2e0',
    'a2' => '7ffc3b104d80',
    'a3' => '0',
    'items' => '2',
    'ppid' => '23256',
    'pid' => '23288',
    'auid' => '1003',
    'uid' => '1003',
    'gid' => '1004',
    'euid' => '1003',
    'suid' => '1003',
    'fsuid' => '1003',
    'egid' => '1004',
    'sgid' => '1004',
    'fsgid' => '1004',
    'tty' => '(none)',
    'ses' => '20327',
    'comm' => 'sshd',
    'exe' => '/usr/sbin/sshd',
    'key' => 'delete',
  }

  context 'given a non-audit event' do
    it 'does nothing' do
      event = 'Something else'
      expect{|b| subject.parse(event, &b)}.to yield_with_args(nil, nil)
    end
  end

  context 'given a valid event' do
    it 'parses the event' do
      expect{|b| subject.parse(UNPARSED_EVENT, &b)}.to yield_with_args(PARSED_EVENT_TIME, PARSED_EVENT_RECORD)
    end
  end

  context 'given an event with a key missing a value' do
    it 'raises a parser error' do
      event = 'type=CWD msg=audit(1488935105.853:413267):  cwd="/" whoops'
      expect{ subject.parse(event) }.to raise_error(Fluent::AuditParser::ParserError)
    end
  end

  context 'given an event with an invalid timestamp' do
    it 'raises a parser error' do
      event = 'type=CWD msg=audit(nope):  cwd="/"'
      expect{ subject.parse(event) }.to raise_error(Fluent::AuditParser::ParserError)
    end
  end
end
