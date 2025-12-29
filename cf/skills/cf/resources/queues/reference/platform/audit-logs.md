# Audit Logs


[Audit logs](https://developers.cloudflare.com/fundamentals/account/account-security/review-audit-logs/) provide a comprehensive summary of changes made within your Cloudflare account, including those made to Queues. This functionality is always enabled.

## Viewing audit logs

To view audit logs for your Queue in the Cloudflare dashboard, go to the **Audit logs** page.

[Go to **Audit logs**](https://dash.cloudflare.com/?to=/:account/audit-log)

For more information on how to access and use audit logs, refer to [Review audit logs](https://developers.cloudflare.com/fundamentals/account/account-security/review-audit-logs/).

## Logged operations

The following configuration actions are logged:

| Operation | Description |
| - | - |
| CreateQueue | Creation of a new queue. |
| DeleteQueue | Deletion of an existing queue. |
| UpdateQueue | Updating the configuration of a queue. |
| AttachConsumer | Attaching a consumer, including HTTP pull consumers, to the Queue. |
| RemoveConsumer | Removing a consumer, including HTTP pull consumers, from the Queue. |
| UpdateConsumerSettings | Changing Queues consumer settings. |


