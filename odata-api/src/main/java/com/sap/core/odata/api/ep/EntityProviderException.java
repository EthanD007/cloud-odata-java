package com.sap.core.odata.api.ep;

import com.sap.core.odata.api.exception.MessageReference;
import com.sap.core.odata.api.exception.ODataMessageException;

public class EntityProviderException extends ODataMessageException {

  private static final long serialVersionUID = 1L;

  public static final MessageReference COMMON = createMessageReference(EntityProviderException.class, "COMMON");

  public static final MessageReference ATOM_TITLE = createMessageReference(EntityProviderException.class, "ATOM_TITLE");

  public static final MessageReference MISSING_PROPERTY = createMessageReference(EntityProviderException.class, "MISSING_PROPERTY");

  public static final MessageReference UNSUPPORTED_PROPERTY_TYPE = createMessageReference(EntityProviderException.class, "UNSUPPORTED_PROPERTY_TYPE");

  public static final MessageReference INLINECOUNT_INVALID = createMessageReference(EntityProviderException.class, "INLINECOUNT_INVALID");;

  public EntityProviderException(MessageReference messageReference) {
    super(messageReference);
  }

  public EntityProviderException(MessageReference messageReference, Throwable cause) {
    super(messageReference, cause);
  }
}
