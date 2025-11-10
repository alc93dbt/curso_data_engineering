{% docs fivetran_deleted %}
Flag indicating if the record has been soft-deleted by Fivetran.
This column is used to mark records that Fivetran has logically deleted but are still present in the warehouse for historical tracking.
{% enddocs %}

{% docs fivetran_synced %}
Date and time when this row was last synchronized by Fivetran from the source system.
Use this field to track the recency of your data loads from the original source.
{% enddocs %}