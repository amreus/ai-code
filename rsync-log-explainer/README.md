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
