=begin
    Copyright 2010-2014 Tasos Laskos <tasos.laskos@gmail.com>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
=end

#
# Simple Remote File Inclusion (and tutorial) module.
#
# It audits links, forms and cookies and will give you a good idea
# of how to write modules for Arachni.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>
#
# @version 0.2
#
# @see http://cwe.mitre.org/data/definitions/94.html
# @see http://projects.webappsec.org/Remote-File-Inclusion
# @see http://en.wikipedia.org/wiki/Remote_File_Inclusion
#
class Arachni::Modules::RFI < Arachni::Module::Base # *always* extend Arachni::Module::Base

    #
    # OPTIONAL
    #
    # Gets called before any other method, right after initialization.
    # It provides you with a way to setup your module's dynamic data.
    #
    def prepare
        #
        # You can use #print_debug for debugging.
        # Don't over-do it though, debugging messages are supposed to be helpful
        # so don't flood the output.
        #
        # Debugging output will only appear if "--debug" is enabled.
        #
        print_debug 'In #prepare'
    end

    #
    # To prepare static data use class methods with lazy loaded class variables.
    #
    # Each module will be run multiple times so there's no sense in constantly
    # initializing the same stuff over and over again and every little helps.
    #

    #
    # It's Framework convention to name the method which contains the strings
    # to be injected {.payloads}.
    #
    def self.payloads
        @payloads ||= [
            'hTtP://tests.arachni-scanner.com/rfi.md5.txt',
            'http://tests.arachni-scanner.com/rfi.md5.txt',
            'tests.arachni-scanner.com/rfi.md5.txt'
        ]
    end

    #
    # It's Framework convention to name the method which contains the audit
    # options {.options}.
    #
    def self.options
        @options ||= {
            substring:       '705cd559b16e6946826207c2199bd890',
            follow_location: false
        }
    end

    #
    # REQUIRED
    #
    # This is used to deliver the module's payload, whatever it may be.
    #
    def run
        print_debug 'In #run'
        audit self.class.payloads, self.class.options
    end

    #
    # OPTIONAL
    #
    # This is called after {#run} has finished executing and it allows you
    # to clean up after yourself.
    #
    def clean_up
        print_debug 'In #clean_up'
    end

    #
    # REQUIRED
    #
    # Do not omit any of the info.
    #
    def self.info
        {
            name:        'Remote File Inclusion',
            description: %q{It injects a remote URL in all available
                inputs and checks for relevant content in the HTTP response body.},
            #
            # Arachni needs to know what elements the module plans to audit
            # before invoking it. If a page doesn't have any of those elements
            # there's no point in running the module.
            #
            # If you want the module to run no-matter what, leave the array
            # empty or don't define it at all.
            #
            elements:    [ Element::FORM, Element::LINK, Element::COOKIE, Element::HEADER ],
            author:      'Tasos "Zapotek" Laskos <tasos.laskos@gmail.com> ',
            version:     '0.2.1',
            references:  {
                'WASC'      => 'http://projects.webappsec.org/Remote-File-Inclusion',
                'Wikipedia' => 'http://en.wikipedia.org/wiki/Remote_File_Inclusion'
            },
            targets:     %w(Generic),

            issue:       {
                name:        %q{Remote File Inclusion},
                description: %q{The web application can be forced to include
    3rd party remote content which can often lead to arbitrary code
    execution, amongst other attacks.},
                tags:       %w(remote file inclusion injection regexp),
                cwe:        '94',
                #
                # Severity can be:
                #
                # Severity::HIGH
                # Severity::MEDIUM
                # Severity::LOW
                # Severity::INFORMATIONAL
                #
                severity:        Severity::HIGH,
                cvssv2:          '7.5',
                remedy_guidance: %q{Enforce strict validation and filtering
                    on user inputs.},
                remedy_code:     '',
                metasploitable:  'unix/webapp/arachni_php_include'
            }

        }
    end

end
