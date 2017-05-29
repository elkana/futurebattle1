xquery version "1.0-ml";
module namespace futurebattleToHtml =
  "http://marklogic.com/rest-api/transform/futurebattle-to-html";

import module namespace json = "http://marklogic.com/xdmp/json"
    at "/MarkLogic/json/json.xqy";

declare namespace ns = "http://kemhan.gov.id/ml";
	
declare function futurebattleToHtml:transform(
        $context as map:map,
        $params as map:map,
        $content as document-node()
) as document-node()
{

    if (fn:empty($content/*))
    then
        $content
    else
        let $_ := xdmp:log(concat("testing....", map:get($context,"uri")))
        let $uri := map:get($context, 'uri')
		(:
        let $xsl_file := concat('/', fn:tokenize($uri,'/')[2],'-html-output.xsl')
        let $_ := xdmp:log(concat("xsl file: ", $xsl_file))
		:)
		
        let $data := $content/node()
        let $_ := xdmp:log('>>>>>>>>>> data is: ')
        let $_ := xdmp:log($data)
		
		(: let $doc_custcc := fn:doc('/mandiri-custcc/WebLogic_Customer_CCdev/000000_0-0-1.json') :)
		let $doc_custcc := $data (: fn:doc('/mandiri-custcc/WebLogic_Customer_CCdev/000000_0-0-1.json') :)
		(:
		let $doc_edctrans := fn:collection('mandiri-edctrans')['Mid'="6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b"]
		let $doc_transcc := fn:collection('mandiri-transcc')[credit_card_no = $doc_custcc/credit_card_no]
		:)
		let $obj := object-node { 
		  'country_name' : $doc_custcc/Country_Name
		 ,'sub_region' : $doc_custcc/Sub_Region
		 ,'afName' : $doc_custcc/Official_Armed_Forced_Name
		 ,'population' : $doc_custcc/Population
		 ,'activePersonnel' : $doc_custcc/Active_Personnel
		 ,'oilProduction' : $doc_custcc/Oil_Production_bbl_per_day
		 ,'landPower' : $doc_custcc/Land_Power
		 ,'airPower' : $doc_custcc/Air_Power
		 ,'seaPower' : $doc_custcc/Sea_Power
		 ,'transportPower' : $doc_custcc/Transport_Power
		 ,'geography' : object-node{'landArea' : $doc_custcc/Land_Area
									,'intRankLand' : $doc_custcc/Int_Rank_Land
									}
		 ,'population' : object-node{'population' : $doc_custcc/Population
									,'intRankPopulation' : $doc_custcc/Int_Ranking_Population
									,'laborForce' : $doc_custcc/Labor_Force
									,'intRankLaborForce' : $doc_custcc/Int_Rank_Labor_Force
									}
						
		(:
		 ,'geography' : array-node{
									object-node{'landArea' : $doc_custcc/Land_Area}
									,object-node{'intRankLand' : $doc_custcc/Int_Rank_Land}
						}
		:)
									(:
		 ,'balance' : $doc_custcc/Balance
		 ,'salary' : $doc_custcc/SalaryPerMonth
		 ,'kids' : $doc_custcc/Kids
		 ,'houses' : $doc_custcc/Houses
		 ,'vehicles' : $doc_custcc/Vehicles
		 ,'last_login_date' : $doc_custcc/LastLoginDate
		 , 'trans_yAxis' : array-node{
          for $item in $doc_transcc
               return xdmp:from-json($item)
          }
		 ,'trans_xAxis' : array-node{(1,2,3,4)}
			:)
		}
		return xdmp:to-json($obj)
};

