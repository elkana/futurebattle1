xquery version "1.0-ml";

module namespace search-dec = "http://marklogic.com/poc/kemhan";

import module namespace dls = "http://marklogic.com/xdmp/dls"
      at "/MarkLogic/dls.xqy";
import module namespace utilities = "http://marklogic.com/utilities"
      at "/lib/utilities.xqy";

declare function search-dec:decorator($uri as xs:string) as node()*
{
      let $doc := fn:doc($uri)
      return (
        attribute country_name {
          $doc/Country_Name
        },
        attribute sub_region {
          $doc/Sub_Region
        },
        attribute afName {
          $doc/Official_Armed_Forced_Name
        },
        attribute population {
          $doc/Population
        },
        attribute activePersonnel {
          $doc/Active_Personnel
        },
        attribute oilProduction {
          $doc/Oil_Production_bbl_per_day
        },
        attribute landPower {
          $doc/Land_Power
        },
        attribute airPower {
          $doc/Air_Power
        },
        attribute seaPower {
          $doc/Sea_Power
        },
        attribute transportPower {
          $doc/Transport_Power
        },
        attribute militarySpending {
          $doc/Nominal_Military_Spending_millions_of_USD
        }
		(:
        attribute militarySpending {
          search-dec:rupiah($doc/Nominal_Military_Spending_millions_of_USD/text())
        }
		:)
      )
};

declare function search-dec:rupiah($rupiah)
{
	fn:string(
		fn:replace(
			fn:normalize-space(
				$rupiah
			), ',', ''
		)
	)
};



