package com.sap.core.odata.core.edm.provider;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import com.sap.core.odata.api.edm.EdmCustomizableFeedMappings;
import com.sap.core.odata.api.edm.EdmEntityType;
import com.sap.core.odata.api.edm.EdmException;
import com.sap.core.odata.api.edm.EdmProperty;
import com.sap.core.odata.api.edm.EdmTypeKind;
import com.sap.core.odata.api.edm.EdmTyped;
import com.sap.core.odata.api.edm.provider.ComplexType;
import com.sap.core.odata.api.edm.provider.EntityType;
import com.sap.core.odata.api.edm.provider.NavigationProperty;
import com.sap.core.odata.api.edm.provider.Property;

public class EdmEntityTypeImplProv extends EdmStructuralTypeImplProv implements EdmEntityType {

  private EntityType entityType;
  private List<EdmProperty> edmKeyProperties;

  public EdmEntityTypeImplProv(EdmImplProv edm, EntityType entityType, String namespace) throws EdmException {
    super(edm, (ComplexType) entityType, EdmTypeKind.ENTITY, namespace);
    this.entityType = entityType;
  }

  @Override
  public Collection<String> getKeyPropertyNames() throws EdmException {
    if (entityType.getKey() == null)
      return Collections.<String> emptyList();
    else
      return entityType.getKey().getKeys().keySet();
  }

  @Override
  public List<EdmProperty> getKeyProperties() throws EdmException {
    if (edmKeyProperties == null) {
      EdmProperty edmProperty;

      edmKeyProperties = new ArrayList<EdmProperty>();
      for (String keyPropertyName : getKeyPropertyNames()) {
        try {
          edmProperty = (EdmProperty) getProperty(keyPropertyName);
        } catch (ClassCastException e) {
          throw new EdmException(e);
        }
        if (edmProperty != null) {
          edmKeyProperties.add(edmProperty);
        } else {
          throw new EdmException();
        }
      }
      if (edmBaseType != null)
        edmKeyProperties.addAll(((EdmEntityType) edmBaseType).getKeyProperties());
    }

    return edmKeyProperties;
  }

  @Override
  public boolean hasStream() throws EdmException {
    return entityType.isHasStream();
  }

  @Override
  public EdmCustomizableFeedMappings getCustomizableFeedMappings() throws EdmException {
    return entityType.getCustomizableFeedMappings();
  }

  @Override
  public Collection<String> getNavigationPropertyNames() throws EdmException {
    return entityType.getNavigationProperties().keySet();
  }

  @Override
  public EdmEntityType getBaseType() throws EdmException {
    return (EdmEntityType) edmBaseType;
  }

  @Override
  protected EdmTyped getPropertyInternal(String name) throws EdmException {
    EdmTyped edmProperty = null;

    Map<String, Property> properties = entityType.getProperties();
    Map<String, NavigationProperty> navigationProperties = entityType.getNavigationProperties();

    if (properties != null && properties.containsKey(name)) {
      edmProperty = createProperty(properties.get(name), name);
      edmProperties.put(name, edmProperty);
    } else if (navigationProperties != null && navigationProperties.containsKey(name)) {
      edmProperty = createNavigationProperty(navigationProperties.get(name));
      edmProperties.put(name, edmProperty);
    } else if (edmBaseType != null) {
      edmProperty = edmBaseType.getProperty(name);
      if (edmProperty != null) {
        edmProperties.put(name, edmProperty);
      }
    }

    return edmProperty;
  }

  protected EdmTyped createNavigationProperty(NavigationProperty property) throws EdmException {
    return new EdmNavigationPropertyImplProv(edm, property);
  }
}