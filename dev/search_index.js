var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = DMARCParser","category":"page"},{"location":"#DMARCParser","page":"Home","title":"DMARCParser","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for DMARCParser.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [DMARCParser]","category":"page"},{"location":"#DMARCParser.dmarc-Tuple{Any}","page":"Home","title":"DMARCParser.dmarc","text":"dmarc(xml_file_name_and_path)\n\nThis function processes a DMARC XML report and returns the data in a DataFrame.\n\nArguments\n\nxml_file_name_and_path::String: The file name and path of the DMARC XML file.\n\nReturns\n\nA DataFrame containing the unformatted (i.e. raw) DMARC data.\n\n\n\n\n\n","category":"method"},{"location":"#DMARCParser.dmarc_formatted-Tuple{Any}","page":"Home","title":"DMARCParser.dmarc_formatted","text":"dmarc_formatted(xml_file_name_and_path)\n\nConverts a DMARC report stored in XML format to a formatted DataFrame.\n\nThis function reads the DMARC report from the specified XML file, processes the data, and returns a formatted DataFrame with the following modifications:\n\nConverts 'begin' and 'end' columns to DateTime objects.\nConverts 'adkim' and 'aspf' columns from \"r\" to \"Relaxed\" and \"s\" to \"Strict\".\nAdds a unique ID column combining row numbers and report IDs.\n\nArguments\n\nxml_file_name_and_path::AbstractString: The file name and path of the DMARC XML file.\n\nReturns\n\nDataFrame: Formatted DataFrame with the processed DMARC file.\n\n\n\n\n\n","category":"method"},{"location":"#DMARCParser.get_dmarc_data-Tuple{Any}","page":"Home","title":"DMARCParser.get_dmarc_data","text":"get_dmarc_data(xml_file_name_and_path)\n\nParse a DMARC (Domain-based Message Authentication, Reporting, and Conformance) XML file and extract relevant information from its sections.\n\nParameters\n\nxml_file_name_and_path::String: The path and filename to the DMARC XML file.\n\nReturns\n\nA dictionary containing consolidated DMARC data \n\nExample\n\nxml_file_name_and_path = \"data/dmarc.xml\"\ndmarc_data = get_dmarc_data(xml_file_name_and_path)\n\n\n\n\n\n","category":"method"},{"location":"#DMARCParser.get_policy_data-Tuple{Any, Any}","page":"Home","title":"DMARCParser.get_policy_data","text":"get_policy_data(policy_elements_vector, number_of_records)\n\nExtracts and processes specified tag names from the Policy section of the DMARC XML file.\n\nArguments\n\npolicy_elements_vector::Vector{Node}: Vector of XML-like elements representing the Policy data.\nnumber_of_records::Int64: Number of record sets in the XML data\n\nReturns\n\nA dictionary containing the specified policy tag names as keys and their corresponding values.\n\n\n\n\n\n","category":"method"},{"location":"#DMARCParser.get_record_data-Tuple{Any, Any}","page":"Home","title":"DMARCParser.get_record_data","text":"get_record_data(record_elements_vector, number_of_records)\n\nExtracts and processes specified tag names from the Record sections of the DMARC XML file.\n\nArguments\n\nrecord_elements_vector::Vector{Node}: Vector of XML-like elements representing the Policy data.\nnumber_of_records::Int64: Number of record sets in the XML data\n\nReturns\n\nA dictionary containing the specified record tag names as keys and their corresponding values.\n\n\n\n\n\n","category":"method"},{"location":"#DMARCParser.get_report_data-Tuple{Any, Any}","page":"Home","title":"DMARCParser.get_report_data","text":"get_report_data(report_elements_vector, number_of_records)\n\nExtracts and processes specified tag names from the Report section of the DMARC XML file.\n\nArguments\n\nreport_elements_vector::Vector{Node}: Vector of XML-like elements representing the Report data.\nnumber_of_records::Int64: Number of record sets in the XML data\n\nReturns\n\nA dictionary containing the specified report tag names as keys and their corresponding values.\n\n\n\n\n\n","category":"method"},{"location":"#DMARCParser.initialize_dataframe-Tuple{Any}","page":"Home","title":"DMARCParser.initialize_dataframe","text":"initialize_dataframe(array_of_columns)\n\nCreate a new DataFrame with empty columns based on the provided array_of_columns.\n\nArguments\n\narray_of_columns::Vector{String}: A vector of String representing the names of the columns to be created in the DataFrame.\n\nReturns\n\nDataFrame: A new DataFrame with empty columns matching the provided column names.\n\n\n\n\n\n","category":"method"},{"location":"#DMARCParser.initialize_dictionary","page":"Home","title":"DMARCParser.initialize_dictionary","text":"initialize_dictionary(array_of_keys, number_of_records = 1)\n\nCreate and initialize a dictionary with keys from array_of_keys and values as arrays of missing values.\n\nArguments\n\narray_of_keys::Vector{String}: An array of unique keys that will be used as dictionary keys.\nnumber_of_records::Int = 1: (Optional) The number of records (size of value arrays) to initialize for each key. Default is 1.\n\nReturns\n\nblank_dictionary::Dict{String, Vector{Union{Missing, String}}}: A dictionary with keys from array_of_keys, and values initialized as arrays of Missing values. Each value array has a size of number_of_records.\n\nNotes\n\nThe array of Missing values is important for indicating which entries are missing in the final output.\n\nExample\n\nkeys = [\"name\", \"age\", \"city\"]\ndict = initialize_dictionary(keys, 3)\n# Output:\n# Dict{String, Vector{Union{Missing, String}}} with 3 entries:\n#   \"name\" => [missing, missing, missing]\n#   \"age\"  => [missing, missing, missing]\n#   \"city\" => [missing, missing, missing]\n\nThis function is useful for creating an empty dictionary with specified keys and initializing the associated arrays with missing values.\n\n\n\n\n\n","category":"function"},{"location":"#DMARCParser.iterate_node","page":"Home","title":"DMARCParser.iterate_node","text":"iterate_node(node::XML.Node, required_tag_names::Vector{String}, results_array::Vector{Tuple{String, String}}=[])\n\nIterates through an XML document tree represented by node and extracts tag-value pairs for elements with tag names found in required_tag_names. It recursively explores the tree structure to handle nested elements.\n\nArguments\n\nnode::XML.Node: The XML node representing the root of the document or subtree.\nrequired_tag_names::Vector{String}: A vector of tag names to be extracted from the XML document.\nresults_array::Vector{Tuple{String, String}}=[]: (Optional) An array to store the extracted tag-value pairs. Default is an empty array.\n\nReturns\n\nThis function does not return a value but populates the results_array with the extracted tag-value pairs.\n\nNotes\n\nThis function is intended for processing the Report and Policy nodes only.\nThe condition length(children(child)) > 0 is used to handle tags that are empty, such as <sp></sp>.\n\n\n\n\n\n","category":"function"},{"location":"#DMARCParser.iterate_record_node","page":"Home","title":"DMARCParser.iterate_record_node","text":"iterate_record_node(node::XML.Node, required_tag_names::Vector{String}, results_array::Vector{Tuple{String, String}}=[], parent_tag::String=\"\")\n\nRecursively iterate through an XML document node and extract specified tag-value pairs.\n\nThis function traverses an XML document node and extracts tag-value pairs based on specified criteria. It recursively explores child nodes, and when it finds a matching tag, it extracts the corresponding value. The extracted tag-value pairs are stored in a results array.\n\nArguments\n\nnode::XML.Node: The XML document node to start the iteration from.\nrequired_tag_names::Vector{String}: A vector of tag names to extract values for.\nresults_array::Vector{Tuple{String, String}}=[]: (Optional) An array to store the extracted tag-value pairs.\nparent_tag::String=\"\": (Optional) The parent tag name for the current node, used to create unique tag names for nested results.\n\nReturns\n\nThis function does not return a value but populates the results_array with the extracted tag-value pairs.\n\nNotes\n\nThis function is for extracting tag-value pairs from the Record XML nodes ondly.\nThe condition length(children(child)) > 0 is used to handle tags that are empty, such as <sp></sp>.\nThis function addresses the issue where the <result> tags may not be unique by modifying the tag names to be unique based on the parent tag.\n\n\n\n\n\n","category":"function"},{"location":"#DMARCParser.populate_dictionary-Tuple{Any, Any}","page":"Home","title":"DMARCParser.populate_dictionary","text":"populate_dictionary(source_results_array, destination_dictionary)\n\nPopulates a destination dictionary with values from a source results array. This function iterates over the source results array, where each record is an array of tuple key-value pairs. It extracts the keys and values from each record and assigns the values to the corresponding key in the destination dictionary, associating them with the corresponding index.\n\nArguments\n\nsource_results_array::Vector{Vector{Tuple{String, String}}}: The source array containing records in the form of an array of tuple key-value pairs.\ndestination_dictionary::Dict{String, Vector{Union{Missing, String}}}: The dictionary to populate with the values from the source array.\n\nReturns\n\nNothing: The function modifies the destination_dictionary in place.\n\nNotes\n\nThe function assumes that the destination_dictionary already exists and is properly initialized before calling this function.\n\nExample\n\nreport_results_array = [[(\"org_name\", \"Outlook.com\"), (\"email\", \"dmarcreport@microsoft.com\"), (\"report_id\", \"c9a3a6172b14410d884df1ac115c670e\"), (\"begin\", \"1646697600\"), (\"end\", \"1646784000\")], \n    [(\"org_name\", \"Outlook.com\"), (\"email\", \"dmarcreport@microsoft.com\"), (\"report_id\", \"c9a3a6172b14410d884df1ac115c670e\"), (\"begin\", \"1646697600\"), (\"end\", \"1646784000\")]]\npopulate_dictionary(report_results_array, report_dictionary)\n# Output:\n# Dict{String, Vector{Union{Missing, String}}} with 5 entries:\n#   \"begin\"     => [\"1646697600\", \"1646697600\"]\n#   \"email\"     => [\"dmarcreport@microsoft.com\", \"dmarcreport@microsoft.com\"]\n#   \"org_name\"  => [\"Outlook.com\", \"Outlook.com\"]\n#   \"end\"       => [\"1646784000\", \"1646784000\"]\n#   \"report_id\" => [\"c9a3a6172b14410d884df1ac115c670e\", \"c9a3a6172b14410d884df1ac115c670e\"]\n\n\n\n\n\n","category":"method"}]
}
