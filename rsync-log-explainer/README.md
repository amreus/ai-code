# Rsync Log Explainer

This Ruby script parses rsync log files and provides explanations for the itemized change codes.

## Usage

To run this script, navigate to the `rsync-log-explainer` directory and execute it with a log file as an argument:

```bash
ruby rsync_log_explainer.rb /path/to/your/rsync.log
```

## Rsync Itemized Change Codes

The script explains the 11-character codes found in rsync logs. Each character in the code signifies a specific aspect of the file transfer or attribute change.

For a detailed breakdown of each character and its possible values, refer to the `RsyncCodeExplanation` hash within the `rsync_log_explainer.rb` file.

## Example Output

```
025/08/09 10:43:50 [116307] >f+++++++++ code/ai-code/rsync-log-explainer/README.md
The file is being transferred to the local host (received).
Regular file.
Checksum is being set for a newly created item.
Size is being set for a newly created item.
Modification time is being set for a newly created item.
Permissions are being set for a newly created item.
Owner is being set for a newly created item.
Group is being set for a newly created item.
Reserved for future use (being set for a newly created item).
ACL information is being set for a newly created item.
Extended attribute information is being set for a newly created item.
```
