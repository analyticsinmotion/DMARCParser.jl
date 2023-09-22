using DMARCParser
using Test
using DataFrames

@testset "DMARCParser.jl" begin
    # Get the path and name for the XML file to test
    #xml_file_name_and_path = "dmarc_xml_files\\protection.outlook.com!analyticsinmotion.com!1646697600!1646784000.xml"
    xml_file_name_and_path = joinpath(@__DIR__, "dmarc_xml_files", "protection.outlook.com!analyticsinmotion.com!1646697600!1646784000.xml")

    # TEST 1
    # Test the get_dmarc_data() function
    # Expected Result - Test 1
    expected_result_1 = Dict("source_ip" => ["40.107.107.116", "40.107.107.112"], "adkim" => ["r", "r"], 
    "sp" => ["none", "none"], "fo" => ["1", "1"], "pct" => ["100", "100"], "selector" => ["selector1", "selector1"], 
    "header_from" => ["analyticsinmotion.com", "analyticsinmotion.com"], "spf_result" => ["pass", "pass"], 
    "end" => ["1646784000", "1646784000"], "report_id" => ["c9a3a6172b14410d884df1ac115c670e", "c9a3a6172b14410d884df1ac115c670e"],
    "begin" => ["1646697600", "1646697600"], "disposition" => ["none", "none"], "aspf" => ["r", "r"], 
    "spf" => ["pass", "pass"], "dkim" => ["pass", "pass"], "org_name" => ["Outlook.com", "Outlook.com"], 
    "domain" => ["analyticsinmotion.com", "analyticsinmotion.com"], "count" => ["1", "1"], "dkim_result" => ["pass", "pass"], 
    "email" => ["dmarcreport@microsoft.com", "dmarcreport@microsoft.com"], "p" => ["none", "none"])

    # Run Test 1
    @test DMARCParser.get_dmarc_data(xml_file_name_and_path) == expected_result_1

    # TEST 2
    # Test the dmarc() function
    # Expected Result - Test 2
    expected_result_2 = DataFrame(
    "report_id" => ["c9a3a6172b14410d884df1ac115c670e", "c9a3a6172b14410d884df1ac115c670e"],
    "begin" => ["1646697600", "1646697600"], 
    "end" => ["1646784000", "1646784000"], 
    "org_name" => ["Outlook.com", "Outlook.com"], 
    "email" => ["dmarcreport@microsoft.com", "dmarcreport@microsoft.com"],
    "domain" => ["analyticsinmotion.com", "analyticsinmotion.com"], 
    "adkim" => ["r", "r"], 
    "aspf" => ["r", "r"], 
    "p" => ["none", "none"],
    "sp" => ["none", "none"], 
    "pct" => ["100", "100"], 
    "fo" => ["1", "1"], 
    "header_from" => ["analyticsinmotion.com", "analyticsinmotion.com"],     
    "source_ip" => ["40.107.107.116", "40.107.107.112"], 
    "count" => ["1", "1"], 
    "disposition" => ["none", "none"], 
    "dkim" => ["pass", "pass"],     
    "dkim_result" => ["pass", "pass"],
    "spf" => ["pass", "pass"], 
    "selector" => ["selector1", "selector1"],     
    "spf_result" => ["pass", "pass"])

    # Run Test 2
    @test DMARCParser.dmarc(xml_file_name_and_path) == expected_result_2






end
