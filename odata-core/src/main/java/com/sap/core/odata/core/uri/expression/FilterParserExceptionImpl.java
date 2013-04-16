package com.sap.core.odata.core.uri.expression;

import com.sap.core.odata.api.edm.EdmException;
import com.sap.core.odata.api.edm.EdmStructuralType;
import com.sap.core.odata.api.edm.EdmType;
import com.sap.core.odata.api.exception.MessageReference;
import com.sap.core.odata.api.exception.ODataBadRequestException;
import com.sap.core.odata.api.uri.expression.BinaryOperator;
import com.sap.core.odata.api.uri.expression.CommonExpression;
import com.sap.core.odata.api.uri.expression.ExpressionParserException;
import com.sap.core.odata.api.uri.expression.PropertyExpression;

/**
 * This class is used to create exceptions of type FilterParserException.
 * Because this class lies inside com.sap.core.odata.core it is possible to define better/more detailed 
 * input parameters for inserting into the exception text.<br>
 * The exception {@link ExpressionParserException} does not know the com.sap.core.odata.core content
 * 
 * @author SAP AG
 */
public class FilterParserExceptionImpl extends ExpressionParserException
{
  private static final long serialVersionUID = 77L;

  static public ExpressionParserException createCOMMON()
  {
    return new ExpressionParserException(ODataBadRequestException.COMMON);
  }

  static public ExpressionParserException createERROR_IN_TOKENIZER(final TokenizerException exceptionTokenizer, final String expression)
  {
    Token token = exceptionTokenizer.getToken();
    MessageReference msgRef = ExpressionParserException.ERROR_IN_TOKENIZER.create();

    msgRef.addContent(token.getUriLiteral());
    msgRef.addContent(Integer.toString(token.getPosition() + 1));
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef, exceptionTokenizer);
  }

  static public ExpressionParserException createINVALID_TRAILING_TOKEN_DETECTED_AFTER_PARSING(final Token token, final String expression)
  {
    MessageReference msgRef = ExpressionParserException.INVALID_TRAILING_TOKEN_DETECTED_AFTER_PARSING.create();

    msgRef.addContent(token.getUriLiteral());
    msgRef.addContent(Integer.toString(token.getPosition() + 1));
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  static public ExpressionParserException createEXPRESSION_EXPECTED_AFTER_POS(final Token token, final String expression)
  {
    MessageReference msgRef = ExpressionParserException.EXPRESSION_EXPECTED_AFTER_POS.create();

    msgRef.addContent(Integer.toString(token.getPosition() + 1));
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  static public ExpressionParserException createEXPRESSION_EXPECTED_AFTER_POS(final int position, final String expression)
  {
    MessageReference msgRef = ExpressionParserException.EXPRESSION_EXPECTED_AFTER_POS.create();

    msgRef.addContent(position);
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  static public ExpressionParserException createCOMMA_OR_END_EXPECTED_AT_POS(final Token token, final String expression)
  {
    MessageReference msgRef = ExpressionParserException.COMMA_OR_END_EXPECTED_AT_POS.create();

    msgRef.addContent(Integer.toString(token.getPosition() + 1));
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  static public ExpressionParserException createEXPRESSION_EXPECTED_AT_POS(final Token token, final String expression)
  {
    MessageReference msgRef = ExpressionParserException.EXPRESSION_EXPECTED_AT_POS.create();

    msgRef.addContent(Integer.toString(token.getPosition() + 1));
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  static public ExpressionParserException createCOMMA_OR_CLOSING_PHARENTHESIS_EXPECTED_AFTER_POS(final Token token, final String expression)
  {
    MessageReference msgRef = ExpressionParserException.COMMA_OR_CLOSING_PHARENTHESIS_EXPECTED_AFTER_POS.create();

    msgRef.addContent(Integer.toString(token.getPosition() + token.getUriLiteral().length()));
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  public static ExpressionParserException createMETHOD_WRONG_ARG_COUNT(final MethodExpressionImpl methodExpression, final Token token, final String expression)
  {
    MessageReference msgRef = null;
    int minParam = methodExpression.getMethodInfo().getMinParameter();
    int maxParam = methodExpression.getMethodInfo().getMaxParameter();

    if ((minParam == -1) && (maxParam == -1))
    {
      //no exception thrown in this case
    }
    else if ((minParam != -1) && (maxParam == -1))
    {
      //Tested with TestParserExceptions.TestPMreadParameters CASE 7-1
      msgRef = ExpressionParserException.METHOD_WRONG_ARG_X_OR_MORE.create();
      msgRef.addContent(methodExpression.getMethod().toUriLiteral());
      msgRef.addContent(token.getPosition() + 1);
      msgRef.addContent(expression);
      msgRef.addContent(minParam);
    }
    else if ((minParam == -1) && (maxParam != -1))
    {
      //Tested with TestParserExceptions.TestPMreadParameters CASE 8-2
      msgRef = ExpressionParserException.METHOD_WRONG_ARG_X_OR_LESS.create();
      msgRef.addContent(methodExpression.getMethod().toUriLiteral());
      msgRef.addContent(token.getPosition() + 1);
      msgRef.addContent(expression);
      msgRef.addContent(maxParam);
    }
    else if ((minParam != -1) && (maxParam != -1))
    {
      if (minParam == maxParam)
      {
        //Tested with TestParserExceptions.TestPMreadParameters CASE 11-1
        msgRef = ExpressionParserException.METHOD_WRONG_ARG_EXACT.create();
        msgRef.addContent(methodExpression.getMethod().toUriLiteral());
        msgRef.addContent(token.getPosition() + 1);
        msgRef.addContent(expression);
        msgRef.addContent(minParam);
      }
      else
      {
        //Tested with TestParserExceptions.TestPMreadParameters CASE 10-1
        msgRef = ExpressionParserException.METHOD_WRONG_ARG_BETWEEN.create();
        msgRef.addContent(methodExpression.getMethod().toUriLiteral());
        msgRef.addContent(token.getPosition() + 1);
        msgRef.addContent(expression);
        msgRef.addContent(minParam);
        msgRef.addContent(maxParam);
      }
    }

    return new ExpressionParserException(msgRef);
  }

  public static ExpressionParserException createMETHOD_WRONG_INPUT_TYPE(final MethodExpressionImpl methodExpression, final Token token, final String expression)
  {
    MessageReference msgRef = null;

    //Tested with TestParserExceptions.TestPMreadParameters CASE 7-1
    msgRef = ExpressionParserException.METHOD_WRONG_INPUT_TYPE.create();
    msgRef.addContent(methodExpression.getMethod().toUriLiteral());
    msgRef.addContent(token.getPosition() + 1);
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  public static ExpressionParserException createLEFT_SIDE_NOT_A_PROPERTY(final Token token, final String expression) throws ExpressionParserInternalError
  {
    MessageReference msgRef = ExpressionParserException.LEFT_SIDE_NOT_A_PROPERTY.create();

    msgRef.addContent(token.getPosition() + 1);
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  public static ExpressionParserException createLEFT_SIDE_NOT_STRUCTURAL_TYPE(final EdmType parentType, final PropertyExpressionImpl property, final Token token, final String expression) throws ExpressionParserInternalError
  {
    MessageReference msgRef = ExpressionParserException.LEFT_SIDE_NOT_STRUCTURAL_TYPE.create();

    try {
      msgRef.addContent(property.getUriLiteral());
      msgRef.addContent(parentType.getNamespace() + "." + parentType.getName());
      msgRef.addContent(token.getPosition() + 1);
      msgRef.addContent(expression);
    } catch (EdmException e) {
      throw ExpressionParserInternalError.createERROR_ACCESSING_EDM(e);
    }

    return new ExpressionParserException(msgRef);
  }

  public static ExpressionParserException createPROPERTY_NAME_NOT_FOUND_IN_TYPE(final EdmStructuralType parentType, final PropertyExpression property, final Token token, final String expression) throws ExpressionParserInternalError
  {
    MessageReference msgRef = ExpressionParserException.PROPERTY_NAME_NOT_FOUND_IN_TYPE.create();

    try {
      msgRef.addContent(property.getUriLiteral());
      msgRef.addContent(parentType.getNamespace() + "." + parentType.getName());
      msgRef.addContent(token.getPosition() + 1);
      msgRef.addContent(expression);
    } catch (EdmException e) {
      throw ExpressionParserInternalError.createERROR_ACCESSING_EDM(e);
    }

    return new ExpressionParserException(msgRef);
  }

  public static ExpressionParserException createTOKEN_UNDETERMINATED_STRING(final int position, final String expression) {
    MessageReference msgRef = ExpressionParserException.TOKEN_UNDETERMINATED_STRING.create();

    msgRef.addContent(position + 1);
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  public static ExpressionParserException createINVALID_TYPES_FOR_BINARY_OPERATOR(final BinaryOperator op, final EdmType left, final EdmType right, final Token token, final String expression) {
    MessageReference msgRef = ExpressionParserException.INVALID_TYPES_FOR_BINARY_OPERATOR.create();

    msgRef.addContent(op.toUriLiteral());

    try {
      msgRef.addContent(left.getNamespace() + "." + left.getName());
    } catch (EdmException e) {
      msgRef.addContent("");
    }
    try {
      msgRef.addContent(right.getNamespace() + "." + right.getName());
    } catch (EdmException e) {
      msgRef.addContent("");
    }
    msgRef.addContent(token.getPosition() + 1);
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  public static ExpressionParserException createMISSING_CLOSING_PHARENTHESIS(final int position, final String expression, final TokenizerExpectError e) {
    MessageReference msgRef = ExpressionParserException.MISSING_CLOSING_PHARENTHESIS.create();

    msgRef.addContent(position + 1);
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef, e);
  }

  public static ExpressionParserException createINVALID_SORT_ORDER(final Token token, final String expression)
  {
    MessageReference msgRef = ExpressionParserException.INVALID_SORT_ORDER.create();
    msgRef.addContent(token.getPosition() + 1);
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);
  }

  public static ExpressionParserException createINVALID_METHOD_CALL(final CommonExpression leftNode, final Token prevToken, final String expression)
  {
    final MessageReference msgRef = ExpressionParserException.INVALID_METHOD_CALL.create();

    msgRef.addContent(leftNode.getUriLiteral());
    msgRef.addContent(prevToken.getPosition() + 1);
    msgRef.addContent(expression);

    return new ExpressionParserException(msgRef);

  }

  public static ExpressionParserException createTYPE_EXPECTED_AT(final EdmType expectedType, final EdmType actualType, final int position, final String expression)
  {
    final MessageReference msgRef = ExpressionParserException.TYPE_EXPECTED_AT.create();

    try {
      msgRef.addContent(expectedType.getNamespace() + '.' + expectedType.getName());
    } catch (EdmException e) {
      msgRef.addContent("");
    }

    msgRef.addContent(position);
    msgRef.addContent(expression);

    if (actualType != null)
    {
      try {
        msgRef.addContent(actualType.getNamespace() + '.' + actualType.getName());
      } catch (EdmException e) {
        msgRef.addContent("");
      }
    }
    else
    {
      msgRef.addContent("null");
    }

    return new ExpressionParserException(msgRef);

  }
}
