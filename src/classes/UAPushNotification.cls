public class UAPushNotification {
	public String[] uniqueDeviceIds;
	public String[] aliases;
	public String[] tags;
	public String alert;
	public Map<String, String> extras;

	public UAPushNotification(String[] apids, String[] aliases, String[] tags, String alert, Map<String, String> extra)
	{
		this.uniqueDeviceIds = apids;
        this.aliases = aliases;
        this.tags = tags;
		this.alert = alert;
		this.extras = extra;
	}

	public String androidJSONString()
	{
		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();

		if (uniqueDeviceIds != null)
		{
			gen.writeObjectField('apids', uniqueDeviceIds);
		}
        
		if (aliases != null)
		{
			gen.writeObjectField('aliases', aliases);
		}
        
		if (tags != null)
		{
			gen.writeObjectField('tags', tags);
		}

		gen.writeFieldName('android');
		gen.writeStartObject();
		gen.writeStringField('alert', alert);

		if (extras != null)
		{
			gen.writeFieldName('extra');
			gen.writeObject(extras);
		}

		gen.writeEndObject();
		gen.writeEndObject();

		return gen.getAsString();
	}
    
    public String iOSJSONString()
	{
		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();

		if (uniqueDeviceIds != null)
		{
			gen.writeObjectField('device_tokens', uniqueDeviceIds);
		}
        
		if (aliases != null)
		{
			gen.writeObjectField('aliases', aliases);
		}
        
		if (tags != null)
		{
			gen.writeObjectField('tags', tags);
		}

		gen.writeFieldName('aps');
		gen.writeStartObject();
		gen.writeStringField('alert', alert);
		gen.writeEndObject();
        
		if (extras != null)
		{
            for(String key : extras.keySet()){
				gen.writeStringField(key, extras.get(key)) ;
            }    
		}
        
		gen.writeEndObject();

		return gen.getAsString();
	}
}