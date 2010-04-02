# This file makes it possible to install RubyCAS-Client as a Rails plugin.

$: << File.expand_path(File.dirname(__FILE__))+'/../../lib'
$: << File.expand_path(File.dirname(__FILE__))+'/../../../fabulator/lib'

require 'fabulator'
require 'fabulator/geo'
require 'spec/expectations'
