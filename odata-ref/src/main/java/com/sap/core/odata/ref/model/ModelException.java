package com.sap.core.odata.ref.model;

/**
 * @author SAP AG
 */
public class ModelException extends RuntimeException {

  private static final long serialVersionUID = 1L;

  public ModelException(Exception e) {
    super(e);
  }

}