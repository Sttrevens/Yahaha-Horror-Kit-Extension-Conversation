local defineFields = {
    {
        name = "content",
        type = {
            type = "list",
            items = {
                type = {
                    type = "object",
                    fields = {
                        {
                            name = "text",
                            type = "string",
                        },
                        {
                            name = "audio",
                            type = "AudioClip",
                        },
                        {
                            name = "showSeconds",
                            type = "float",
                        },
                    }
                }
            }
        }
    }
}

script.DefineFields(defineFields)