using XML

export iterate_node,
       iterate_record_node,
       initialize_dictionary,
       populate_dictionary,
       get_report_data,
       get_policy_data,
       get_record_data,
       get_dmarc_data


"""
    iterate_node(node::XML.Node, required_tag_names::Vector{String}, results_array::Vector{Tuple{String, String}}=[])

Iterates through an XML document tree represented by `node` and extracts tag-value pairs for elements
with tag names found in `required_tag_names`. It recursively explores the tree structure to handle nested elements.

# Arguments
- `node::XML.Node`: The XML node representing the root of the document or subtree.
- `required_tag_names::Vector{String}`: A vector of tag names to be extracted from the XML document.
- `results_array::Vector{Tuple{String, String}}=[]`: (Optional) An array to store the extracted tag-value pairs.
  Default is an empty array.

# Returns
- This function does not return a value but populates the `results_array` with the extracted tag-value pairs.

# Notes
- This function is intended for processing the Report and Policy nodes only.
- The condition `length(children(child)) > 0` is used to handle tags that are empty, such as `<sp></sp>`.

"""
function iterate_node(node::XML.Node, required_tag_names::Vector{String}, results_array::Vector{Tuple{String, String}}=[])
    for child in children(node)
        if nodetype(child) == XML.Element && length(children(child)) > 0 && tag(child) in required_tag_names
            tag_value_tuple = (tag(child), value(child[1]))
            push!(results_array, tag_value_tuple)
        end
        
        # Recursively check if the child has its own children
        iterate_node(child, required_tag_names, results_array)
    end
end


"""
    iterate_record_node(node::XML.Node, required_tag_names::Vector{String}, results_array::Vector{Tuple{String, String}}=[], parent_tag::String="")

Recursively iterate through an XML document node and extract specified tag-value pairs.

This function traverses an XML document node and extracts tag-value pairs based on specified criteria.
It recursively explores child nodes, and when it finds a matching tag, it extracts the corresponding value.
The extracted tag-value pairs are stored in a results array.

# Arguments
- `node::XML.Node`: The XML document node to start the iteration from.
- `required_tag_names::Vector{String}`: A vector of tag names to extract values for.
- `results_array::Vector{Tuple{String, String}}=[]`: (Optional) An array to store the extracted tag-value pairs.
- `parent_tag::String=""`: (Optional) The parent tag name for the current node, used to create unique tag names for nested results.

# Returns
- This function does not return a value but populates the `results_array` with the extracted tag-value pairs.

# Notes
- This function is for extracting tag-value pairs from the Record XML nodes ondly.
- The condition `length(children(child)) > 0` is used to handle tags that are empty, such as `<sp></sp>`.
- This function addresses the issue where the `<result>` tags may not be unique by modifying the tag names to be unique based on the parent tag.

"""
function iterate_record_node(node::XML.Node, required_tag_names::Vector{String}, results_array::Vector{Tuple{String, String}}=[], parent_tag::String="")
    for child in children(node)
        if nodetype(child) == XML.Element && length(children(child)) > 0
            child_tag = tag(child)
            child_value = value(child[1])
            
            # Fix the record set element names to remove the <results> duplicate tag name
            if child_tag == "result"
                new_tag_name = "$parent_tag" * "_" * "$child_tag"
                tag_value_tuple = (new_tag_name, child_value)
                push!(results_array, tag_value_tuple)
            elseif child_value !== nothing && tag(child) in required_tag_names
                tag_value_tuple = (tag(child), value(child[1]))
                push!(results_array, tag_value_tuple)
            end
            
            iterate_record_node(child, required_tag_names, results_array, child_tag)
        end
    end
end


"""
    initialize_dictionary(array_of_keys, number_of_records = 1)

Create and initialize a dictionary with keys from `array_of_keys` and values as arrays of missing values.

# Arguments
- `array_of_keys::Vector{String}`: An array of unique keys that will be used as dictionary keys.
- `number_of_records::Int = 1`: (Optional) The number of records (size of value arrays) to initialize for each key. Default is 1.

# Returns
- `blank_dictionary::Dict{String, Vector{Union{Missing, String}}}`: A dictionary with keys from `array_of_keys`, and values initialized as arrays of `Missing` values. Each value array has a size of `number_of_records`.

# Notes
- The array of Missing values is important for indicating which entries are missing in the final output.

# Example
```julia
keys = ["name", "age", "city"]
dict = initialize_dictionary(keys, 3)
# Output:
# Dict{String, Vector{Union{Missing, String}}} with 3 entries:
#   "name" => [missing, missing, missing]
#   "age"  => [missing, missing, missing]
#   "city" => [missing, missing, missing]
```
This function is useful for creating an empty dictionary with specified keys and initializing the associated arrays with missing values.

"""
function initialize_dictionary(array_of_keys, number_of_records = 1)
    blank_dictionary = Dict{String, Vector{Union{Missing, String}} }(key => fill(missing, number_of_records) for key in array_of_keys)
    return blank_dictionary
end


"""
    populate_dictionary(source_results_array, destination_dictionary)

Populates a destination dictionary with values from a source results array. This function iterates over the source results array, where each record is an array of tuple key-value pairs. It extracts the keys and values from each record and assigns the values to the corresponding key in the destination dictionary, associating them with the corresponding index.

# Arguments
- `source_results_array::Vector{Vector{Tuple{String, String}}}`: The source array containing records in the form of an array of tuple key-value pairs.
- `destination_dictionary::Dict{String, Vector{Union{Missing, String}}}`: The dictionary to populate with the values from the source array.

# Returns
- `Nothing`: The function modifies the `destination_dictionary` in place.

# Notes
- The function assumes that the destination_dictionary already exists and is properly initialized before calling this function.

# Example
```julia
report_results_array = [[("org_name", "Outlook.com"), ("email", "dmarcreport@microsoft.com"), ("report_id", "c9a3a6172b14410d884df1ac115c670e"), ("begin", "1646697600"), ("end", "1646784000")], 
    [("org_name", "Outlook.com"), ("email", "dmarcreport@microsoft.com"), ("report_id", "c9a3a6172b14410d884df1ac115c670e"), ("begin", "1646697600"), ("end", "1646784000")]]
populate_dictionary(report_results_array, report_dictionary)
# Output:
# Dict{String, Vector{Union{Missing, String}}} with 5 entries:
#   "begin"     => ["1646697600", "1646697600"]
#   "email"     => ["dmarcreport@microsoft.com", "dmarcreport@microsoft.com"]
#   "org_name"  => ["Outlook.com", "Outlook.com"]
#   "end"       => ["1646784000", "1646784000"]
#   "report_id" => ["c9a3a6172b14410d884df1ac115c670e", "c9a3a6172b14410d884df1ac115c670e"]
```

"""
function populate_dictionary(source_results_array, destination_dictionary)
    for (index,record) in enumerate(source_results_array)
        for (key, value) in record
            destination_dictionary[key][index] = value
        end
    end
end


"""
    get_report_data(report_elements_vector, number_of_records)

Extracts and processes specified tag names from the Report section of the DMARC XML file.

# Arguments
- `report_elements_vector::Vector{Node}`: Vector of XML-like elements representing the Report data.
- `number_of_records::Int64`: Number of record sets in the XML data

# Returns
- A dictionary containing the specified report tag names as keys and their corresponding values.

"""
function get_report_data(report_elements_vector, number_of_records)
    
    # Step 1: - Specify the tag names required from report
    report_tag_names = ["report_id","begin","end","org_name","email"]
    
    # Step 2: - Initialize a blank array to hold the data as a key/value tuple
    report_results_array = Vector{Tuple{String, String}}()
    
    # Step 3: - Call the function to iterate over the report section XML and extract the required tag names and values
    iterate_node(report_elements_vector[1], report_tag_names, report_results_array)
    
    # Step 4: - Duplicate the vector data in report by the number of records. 
    report_results_array = [report_results_array for _ in 1:number_of_records]
    
    # Step 5 - Specify the required fields for the final output
    report_names = ["report_id","begin","end","org_name","email"]
    
    # Step 6 - Initialize a dictionary containing the report_names as keys and an array of missing for the values
    report_results_array_count = length(report_results_array)
    report_dictionary = initialize_dictionary(report_names, report_results_array_count)
    
    # Step 7 - Call the function to populate the dictionary from the report_results_array
    populate_dictionary(report_results_array, report_dictionary)
    
    # Step 8 - Return the populated report_dictionary
    return report_dictionary
    
end


"""
    get_policy_data(policy_elements_vector, number_of_records)

Extracts and processes specified tag names from the Policy section of the DMARC XML file.

# Arguments
- `policy_elements_vector::Vector{Node}`: Vector of XML-like elements representing the Policy data.
- `number_of_records::Int64`: Number of record sets in the XML data

# Returns
- A dictionary containing the specified policy tag names as keys and their corresponding values.

"""
function get_policy_data(policy_elements_vector, number_of_records)
    
    # Step 1: - Specify the tag names required from report
    policy_tag_names = ["domain","adkim","aspf","p","sp","pct","fo"]
    
    # Step 2: - Initialize a blank array to hold the data as a key/value tuple
    policy_results_array = Vector{Tuple{String, String}}()
    
    # Step 3: - Call the function to iterate over the policy section XML and extract the required tag names and values
    iterate_node(policy_elements_vector[1], policy_tag_names, policy_results_array)
    
    # Step 4: - Duplicate the vector data in report by the number of records. 
    policy_results_array = [policy_results_array for _ in 1:number_of_records]
    
    # Step 5 - Specify the required fields for the final output
    policy_names = ["domain","adkim","aspf","p","sp","pct","fo"]
    
    # Step 6 - Initialize a dictionary containing the policy_names as keys and an array of missing for the values
    policy_results_array_count = length(policy_results_array)
    policy_dictionary = initialize_dictionary(policy_names, policy_results_array_count)
    
    # Step 7 - Call the function to populate the dictionary from the policy_results_array
    populate_dictionary(policy_results_array, policy_dictionary)
    
    # Step 8 - Return the populated report_dictionary
    return policy_dictionary
    
end


"""
    get_record_data(record_elements_vector, number_of_records)

Extracts and processes specified tag names from the Record sections of the DMARC XML file.

# Arguments
- `record_elements_vector::Vector{Node}`: Vector of XML-like elements representing the Policy data.
- `number_of_records::Int64`: Number of record sets in the XML data

# Returns
- A dictionary containing the specified record tag names as keys and their corresponding values.

"""
function get_record_data(record_elements_vector, number_of_records)
    
    # Step 1: - Specify the tag names required from report
    record_tag_names = ["header_from","source_ip","count","disposition","dkim","result","spf","selector"];
    
    # Step 2: - Initialize two blank arrays to process the records data
    # Initialize a blank array specifying its format as a single array
    all_record_results_array = Vector{Tuple{String, String}}() 
    # Initialize another blank array specifying its format as a nested array
    record_results_array::Vector{Vector{Tuple{String, String}}} = []

    # Step 3: - Call the function based on the number of record sets
    for record in 1:number_of_records
        iterate_record_node(record_elements_vector[record], record_tag_names, all_record_results_array)
        push!(record_results_array, all_record_results_array)
        all_record_results_array = Vector{Tuple{String, String}}()
    end
    
    # Step 4 - Specify the required fields for the final output
    record_names = ["header_from","source_ip","count","disposition","dkim","dkim_result","spf","selector","spf_result"]
    
    # Step 6 - Initialize a dictionary containing the report_names as keys and an array of missing for the values
    record_results_array_count = length(record_results_array)
    record_dictionary = initialize_dictionary(record_names, record_results_array_count)
    
    # Step 7 - Call the function to populate the dictionary from the report_results_array
    populate_dictionary(record_results_array, record_dictionary)
    
    # Step 8 - Return the populated report_dictionary
    return record_dictionary
    
end


"""
    get_dmarc_data(xml_file_name_and_path)

Parse a DMARC (Domain-based Message Authentication, Reporting, and Conformance) XML file and extract relevant information from its sections.

# Parameters
- `xml_file_name_and_path::String`: The path and filename to the DMARC XML file.

# Returns
- A dictionary containing consolidated DMARC data 

# Example
```julia
xml_file_name_and_path = "data/dmarc.xml"
dmarc_data = get_dmarc_data(xml_file_name_and_path)
```

"""
function get_dmarc_data(xml_file_name_and_path)
    
    # Create a raw string of the XML file name and path 
    xml_file = """$xml_file_name_and_path"""
    
    # Load the entire XML DOM in memory
    xml_tree = read(xml_file, Node)
    
    # Split dmarc xml file into the three main sections
    report_elements_vector = xml_tree[end] |> children |> filter(node -> tag(node) == "report_metadata")
    policy_elements_vector = xml_tree[end] |> children |> filter(node -> tag(node) == "policy_published")
    record_elements_vector = xml_tree[end] |> children |> filter(node -> tag(node) == "record")
    
    # Identify the number of record sets in the record section
    number_of_records = length(record_elements_vector)
    
    # Get the data from each section
    report_dictionary = get_report_data(report_elements_vector, number_of_records)
    policy_dictionary = get_policy_data(policy_elements_vector, number_of_records)
    record_dictionary = get_record_data(record_elements_vector, number_of_records)
    
    # Merge the three completed dictionaries together
    dmarc_dictionary = merge(report_dictionary, policy_dictionary,record_dictionary)
    
    
    # Return a consolidated dictionary of dmarc data
    return dmarc_dictionary
    
end

