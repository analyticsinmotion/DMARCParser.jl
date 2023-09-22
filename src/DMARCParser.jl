module DMARCParser

using DataFrames
using Dates

include("get_dmarc_data.jl")

export dmarc,
       dmarc_formatted,
       initialize_dataframe


"""
    initialize_dataframe(array_of_columns)

Create a new DataFrame with empty columns based on the provided `array_of_columns`.

# Arguments
- `array_of_columns::Vector{String}`: A vector of String representing the names of the columns to be created in the DataFrame.

# Returns
- `DataFrame`: A new DataFrame with empty columns matching the provided column names.

"""
function initialize_dataframe(array_of_columns)
    blank_dataframe = DataFrame([Vector{Union{String, Missing}}() for _ in 1:length(array_of_columns)], array_of_columns)
    return blank_dataframe
end


"""
    dmarc(xml_file_name_and_path)

This function processes a DMARC XML report and returns the data in a DataFrame.

# Arguments
- `xml_file_name_and_path::String`: The file name and path of the DMARC XML file.

# Returns
A DataFrame containing the unformatted (i.e. raw) DMARC data.


"""
function dmarc(xml_file_name_and_path)
    
    # Step 1 - Specify the column headings for the dmarc report
    dmarc_dataframe_columns = ["report_id","begin","end","org_name","email","domain","adkim","aspf","p","sp","pct","fo","header_from","source_ip","count","disposition","dkim","dkim_result","spf","selector","spf_result"]
    
    # Step 2 - Initialize dmarc Dataframe
    dmarc_dataframe = initialize_dataframe(dmarc_dataframe_columns)
    
    # Step 3 - Parse XML file to get required data 
    dmarc_dictionary = get_dmarc_data(xml_file_name_and_path)
    
    # Step 4 - Add data to the dataframe
    dmarc_dataframe = DataFrame(dmarc_dictionary)
    
    # Step 5 - Reorder according to the column array
    dmarc_dataframe = dmarc_dataframe[!, dmarc_dataframe_columns]
    
    # Step 6 - Return the datafram
    return dmarc_dataframe    

end


"""
    dmarc_formatted(xml_file_name_and_path)

Converts a DMARC report stored in XML format to a formatted DataFrame.

This function reads the DMARC report from the specified XML file, processes the data, and returns a formatted DataFrame with the following modifications:
1. Converts 'begin' and 'end' columns to DateTime objects.
2. Converts 'adkim' and 'aspf' columns from "r" to "Relaxed" and "s" to "Strict".
3. Adds a unique ID column combining row numbers and report IDs.

# Arguments
- `xml_file_name_and_path::AbstractString`: The file name and path of the DMARC XML file.

# Returns
- `DataFrame`: Formatted DataFrame with the processed DMARC file.

"""
function dmarc_formatted(xml_file_name_and_path)
    
    # Step 1 - Get the raw dataframe
    dmarc_report = dmarc(xml_file_name_and_path)
    
    # Step 2 - Convert begin column to date time unless it has missing
    if any(ismissing.(dmarc_report.begin)) === false
        dmarc_report.begin = parse.(Int64, dmarc_report.begin)
        dmarc_report[!, :begin] .= Dates.unix2datetime.(dmarc_report[!, :begin])
    end
        
    # Step 3 - Convert end column to date time unless it has missing
    if any(ismissing.(dmarc_report.end)) === false
        dmarc_report.end = parse.(Int64, dmarc_report.end)
        dmarc_report[!, :end] .= Dates.unix2datetime.(dmarc_report[!, :end])
    end

    # Step 4 - Add Alignment mode definitions - "r" is "Relaxed and "s" is "Strict" 
    replace!(dmarc_report.adkim, "r" => "Relaxed", "s" => "Strict")
    replace!(dmarc_report.aspf, "r" => "Relaxed", "s" => "Strict")

    # Step 5 - Add a unique ID column - just add the row number as a prefix to report_id 
    dmarc_report[!, :u_id] = [string(i, "-", dmarc_report.report_id[i]) for i in 1:nrow(dmarc_report)]

    # Final Step
    return dmarc_report

end



end
