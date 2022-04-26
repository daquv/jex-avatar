package com.avatar.comm;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.StringTokenizer;

import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

public class XmlToMap extends DefaultHandler {
    private String _strColumnToken = "";
    private String _strRowToken = "";

    // 분석된 결과.
    private HashMap<String, Object> _parserHashMap;

    // 분석중 Record 정보를 Stack 형태로 사용할 List
    private LinkedList<Object> _parserList;

    // 분석하고 있는 Nodeid
    private String _strNodeID;

    // 분석하고 있는 시점의 Map
    private HashMap<String, Object> _hashDataMap;

    // 분석중 Map 정보를 Stack 형태로 사용할 List
    private LinkedList<Object> _linkMapList;

    // 분석중 발생한 오류 정보
    private Throwable _throwable;

    // XML인코딩
    private String _strXmlEnc;

    // Record 가 압축 모드 인지
    private boolean _bCompmode = false;

    // Recodes 가 압축모드일때의 Records 정보
    private String _strRecordsNodeId;

    // Record가 압축모드일때의 Record 정보
    private String _strRecordNodeId;

    // String 정보를 저장할 버퍼
    private StringBuffer _sbCharBuffer;

    private String _strTaskId;

    private String _strTarget;

    public XmlToMap() {
        this("euc-kr");
    }

    public XmlToMap(String enc) {
        setXmlEnc(enc);
    }

    public HashMap<String, Object> getMap() {
        return _parserHashMap;
    }

    private void createParserInfo() {
        _parserHashMap = new HashMap<String, Object>();
        _hashDataMap = _parserHashMap;
    }

    private LinkedList<Object> getMapList() {
        if (_linkMapList == null)
            _linkMapList = new LinkedList<Object>();
        return _linkMapList;
    }

    private HashMap<String, Object> getDataMap() {
        return _hashDataMap;
    }

    private LinkedList<Object> getRecordInfo() {
        return _parserList;
    }

    private void createRecord(String id) {
        if (_parserList != null)
            getMapList().add(_parserList);
        _parserList = new LinkedList<Object>();
        getDataMap().put(id, _parserList);
    }

    private void nextRecord() {
        HashMap<String, Object> map = new HashMap<String, Object>();
        getRecordInfo().add(map);
        _hashDataMap = map;
    }

    private void endRecord() {
        _parserList = null;
        if (getMapList().size() < 1) {
            _hashDataMap = getMap();
        } else {
            _parserList = (LinkedList<Object>) getMapList().remove(getMapList().size() - 1);

            if (_parserList.size() > 0) {
                _hashDataMap = (HashMap<String, Object>) _parserList.getLast();
            } else {
                HashMap<String, Object> map = new HashMap<String, Object>();
                _parserList.add(map);
                _hashDataMap = map;
            }
        }
    }

    public boolean parser(String data) {
        return parser(data.getBytes());
    }

    public boolean parser(byte b[]) {
        ByteArrayInputStream byteInput = null;
        try {
            byteInput = new ByteArrayInputStream(b);
            return parser(byteInput);
        } finally {
            try {
                byteInput.close();
            } catch (Exception e) {
            }
        }
    }

    public boolean parser(InputStream input) {
        try {
            InputSource sourceInput = new InputSource(input);
            sourceInput.setEncoding(getXmlEnc());

            XMLReader parser = XMLReaderFactory.createXMLReader();

            parser.setContentHandler(this);
            parser.setDTDHandler(this);
            parser.setErrorHandler(this);

            parser.parse(sourceInput);

        } catch (Exception e) {
            setErrorLog("XmlToParserInfo", "Exception [" + e + "]");
            _throwable = e;
            e.printStackTrace();
            return false;
        }

        return (getMap() != null && getMap().size() > 0);
    }

    public Throwable getThrowable() {
        return _throwable;
    }

    @Override
    public void startDocument() throws SAXException {
        createParserInfo();
    }

    @Override
    public void startElement(String uri, String localpart, String rawname,
            Attributes atts) throws SAXException {
        _sbCharBuffer = null;
        if ("nodes".equals(rawname)) {
            if (atts.getValue("id") != null)
                _strTaskId = atts.getValue("id").trim();
            if (atts.getValue("target") != null)
                _strTarget = atts.getValue("target").trim();
        } else if ("node".equals(rawname) || "binary".equals(rawname)) {
            _strNodeID = atts.getValue("id").trim();
        } else if ("records".equals(rawname)) {
            createRecord(atts.getValue("id").trim());
            _bCompmode = "true".equals(atts.getValue("comp"));
            _strRecordsNodeId = atts.getValue("list");
            setRowToken(atts.getValue("row"));
            setColumnToken(atts.getValue("col"));

        } else if ("record".equals(rawname)) {
            _strRecordNodeId = atts.getValue("list");
            _bCompmode = "true".equals(atts.getValue("comp"));
            setColumnToken(atts.getValue("col"));
            nextRecord();
        }
    }

    @Override
    public void characters(char ch[], int offset, int length)
            throws SAXException {
        getCharBuffer().append(new String(ch, offset, length).trim());
    }

    private StringBuffer getCharBuffer() {
        if (_sbCharBuffer == null) {
            _sbCharBuffer = new StringBuffer();
        }
        return _sbCharBuffer;
    }

    @Override
    public void endElement(String uri, String localpart, String rawname)
            throws SAXException {
        if (_strNodeID != null) {
            // Node 가 종료 될때..남아 있는 자료가 StringBuffer 이면.. 가공을 해야 한다.
            if (_sbCharBuffer != null) {
                StringBuffer sbTmp = getCharBuffer();

                {
                    getDataMap().put(_strNodeID, sbTmp.toString());
                }
            } else {
                getDataMap().put(_strNodeID, "");
            }
        }
        if ("node".equals(rawname) || "binary".equals(rawname)) {
            _strNodeID = null;
        } else if ("record".equals(rawname)) {

            if (_bCompmode && _sbCharBuffer != null) {
                String data = getCharBuffer().toString();
                StringTokenizer stId = new StringTokenizer(
                        (_strRecordNodeId != null) ? _strRecordNodeId
                                : _strRecordsNodeId, getColumnToken());
                StringTokenizer stValue = new StringTokenizer(data,
                        getColumnToken());
                String strKey;
                while (stId.hasMoreTokens()) {
                    strKey = stId.nextToken();
                    try {
                        getDataMap().put(strKey, stValue.nextToken());
                    } catch (Exception e) {
                        getDataMap().put(strKey, "");
                    }
                }
            }
            _bCompmode = false;
        } else if ("records".equals(rawname)) {
            if (_bCompmode && _sbCharBuffer != null) {
                String data = getCharBuffer().toString();
                StringTokenizer stRow = new StringTokenizer(data, getRowToken());
                StringTokenizer stColumn;
                StringTokenizer stId;
                String strIds = (_strRecordNodeId != null) ? _strRecordNodeId
                        : _strRecordsNodeId;
                String strKey;

                while (stRow.hasMoreTokens()) {
                    nextRecord();
                    stColumn = new StringTokenizer(data, getColumnToken());
                    stId = new StringTokenizer(strIds, getColumnToken());
                    while (stId.hasMoreTokens())
                        ;
                    {
                        strKey = stId.nextToken();

                        try {
                            getDataMap().put(strKey,
                                    stColumn.nextToken().trim());
                        } catch (Exception e) {
                            getDataMap().put(strKey, "");
                        }
                    }
                }
            }
            endRecord();
            _bCompmode = false;
            _strRecordsNodeId = null;
            _strRecordNodeId = null;
        }
    }

    @Override
    public void warning(SAXParseException ex) {
        // setErrorLog("XmlToParserInfo", "[Warning] " + getLocationString(ex) +
        // ": " + ex.getMessage());
    }

    @Override
    public void error(SAXParseException ex) {
        setErrorLog("XmlToParserInfo", "[Error1] " + getLocationString(ex)
                + ": " + ex.getMessage());
    }

    @Override
    public void fatalError(SAXParseException ex) throws SAXException {
        setErrorLog("XmlToParserInfo", "[Fatal Error] " + getLocationString(ex)
                + ": " + ex.getMessage());
        throw ex;
    }

    private String getLocationString(SAXParseException ex) {
        StringBuffer str = new StringBuffer();
        String systemId = ex.getSystemId();
        if (systemId != null) {
            int index = systemId.lastIndexOf('/');
            if (index != -1)
                systemId = systemId.substring(index + 1);
            str.append(systemId);
        }
        str.append(':');
        str.append(ex.getLineNumber());
        str.append(':');
        str.append(ex.getColumnNumber());
        return str.toString();
    }

    public void setLog(String title, String data) {
        System.out.println(data);
    }

    public void setErrorLog(String title, String data) {
        System.out.println(data);
    }

    public void setXmlEnc(String enc) {
        _strXmlEnc = enc;
    }

    public String getXmlEnc() {
        return _strXmlEnc;
    }

    /**
     * @return columnToken을 리턴합니다.
     */
    public String getColumnToken() {
        return _strColumnToken;
    }

    /**
     * @param columnToken
     *            설정하려는 columnToken.
     */
    public void setColumnToken(String columnToken) {
        _strColumnToken = columnToken;
    }

    /**
     * @return rowToken을 리턴합니다.
     */
    public String getRowToken() {
        return _strRowToken;
    }

    /**
     * @param rowToken
     *            설정하려는 rowToken.
     */
    public void setRowToken(String rowToken) {
        _strRowToken = rowToken;
    }

    /**
     * @return target을 리턴합니다.
     */
    public String getTarget() {
        return _strTarget;
    }

    /**
     * @return taskId을 리턴합니다.
     */
    public String getTaskId() {
        return _strTaskId;
    }

}
