{
    ------------------------------------------------------------------------------
    Translated into pascal with help of h2pas utility from the FreePascal project.
    Copyright for the header translation:
        4commerce technologies AG
        Kamerbalken 10-14
        22525 Hamburg, Germany
    Published under a double license:
    a) the GNU Library General Public License: 
       http://www.gnu.org/copyleft/lgpl.html
    b) the Mozilla Public License:
       http://www.mozilla.org/MPL/MPL-1.1.html
    Please send corrections to: ufechner@4commerce.de
    ------------------------------------------------------------------------------
}
  {
     numbers.h: Implementation of the XSLT number functions
    
     See Copyright for the status of this software.
    
     daniel@veillard.com
     Bjorn Reese <breese@users.sourceforge.net>
    }

  { 
     xsltNumberData:
    
     This data structure is just a wrapper to pass xsl:number data in
    }

  type

     xsltNumberData = record
          level : PxmlChar;
          count : PxmlChar;
          from : PxmlChar;
          value : PxmlChar;
          format : PxmlChar;
          has_format : longint;
          digitsPerGroup : longint;
          groupingCharacter : xmlChar;
          doc : xmlDocPtr;
          node : xmlNodePtr;
       end;

     xsltNumberDataPtr = ^xsltNumberData;

     _xsltNumberData = xsltNumberData;
  { 
     xsltFormatNumberInfo,:
    
     This data structure lists the various parameters needed to format numbers
    }
     xsltFormatNumberInfo = record
          integer_digits : longint;     { Number of '0' in integer part  }
          frac_digits : longint;        { Number of '0' in fractional part  }
          frac_hash : longint;          { Number of '#' in fractional part  }
          group : longint;              { Number of chars per display 'group'  }
          multiplier : longint;         { Scaling for percent or permille  }
          is_multiplier_set : char;     { Flag to catch multiple occurences of percent/permille  }
          is_negative_pattern : char;   { Flag for processing -ve prefix/suffix  }
       end;

     xsltFormatNumberInfoPtr = ^xsltFormatNumberInfo;

     _xsltFormatNumberInfo = xsltFormatNumberInfo;


