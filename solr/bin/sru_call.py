#!/usr/bin/env python

import getopt
import sys
import xml.sax


class MarcHandler(xml.sax.handler.ContentHandler):
    def __init__(self):
        self.flag = 0

    _field = None
    _tag = None
    _code = None

    identifier = None

    def startElement(self, name, atts):
        if 'tag' in atts:
            self._tag = atts['tag']
        elif 'code' in atts:
            self._code = atts['code']
        self._field = name


    def characters(self, content):
        if self._tag == '001':
            self.identifier = content


    # tcn
    # Return the tcn value when we found control field 001
    def tcn(self):
        return self.identifier if self.identifier else ''


def usage():
    print('Usage: sru_call.py --url [sru endpoint]')


def main(argv):
    url = None

    try:
        opts, args = getopt.getopt(argv, 'hu:',['help', 'url='])
    except getopt.GetoptError as e:
        print("Opt error: " + e.msg)
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        if opt in ('-u', '--url'):
            url = arg

    assert url

    handler = MarcHandler()
    xml.sax.parse(url, handler)
    print(handler.tcn())



if __name__ == '__main__':
    main(sys.argv[1:])